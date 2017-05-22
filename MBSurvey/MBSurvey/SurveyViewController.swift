//
//  SurveyViewController.swift
//  MBSurvey
//
//  Created by Mirko Babic on 2/2/17.
//  Copyright © 2017 Happy Boar. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var survey: Survey!
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    survey.nextQuestion()
    collectionView.reloadData()
  }
}

extension SurveyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return survey.questionSequel.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch survey.currentSequelType {
    case .question:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! QuestionCollectionViewCell
      cell.rightButton.isEnabled = false
      cell.topLabel.text = survey.currentQuestion?.question ?? "Results"
      
      cell.delegate = self
      cell.tableView.dataSource = self
      cell.tableView.delegate = self
      cell.tableView.reloadData()
      
      return cell
    case .result:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath) as! ResultsCollectionViewCell
      cell.rightButton.isEnabled = true
      cell.topLabel.text = "Results"
      cell.leftButton.isHidden = true
      cell.rightButton.setTitle("Finish", for: .normal)
      cell.delegate = self
      cell.tableView.dataSource = self
      cell.tableView.delegate = self
      cell.tableView.reloadData()
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView is UICollectionView {
      collectionView.reloadData()
    }
  }
}

extension SurveyViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if survey.currentSequelType == .question {
      return survey.currentQuestion!.answers.count
    } else {
      return survey.answeredQuestions.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch survey.currentSequelType {
    case .question:
      let question = survey.currentQuestion!
      let answer = question.answers[indexPath.row]
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! AnswerTableViewCell
      
      cell.answerLabel.text = "\(indexPath.row + 1). " + answer.answer
      
      if question.selectedAnswers.contains(answer) {
        cell.checkImageView.image = #imageLiteral(resourceName: "answerbuttonselected_icon")
      } else {
        cell.checkImageView.image = #imageLiteral(resourceName: "answerbutton_icon")
      }
      return cell
    case .result:
      /// HOT FIX - Even though collectionView loads this tableView for results it tries to modify earlier collectionViewCells tableView and app crashes
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") else {
        return UITableViewCell()
      }
      let question = survey.answeredQuestions[indexPath.row]
      cell.textLabel?.text = "\(indexPath.row + 1). " + question.question
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if survey.currentSequelType == .question {
      tableView.deselectRow(at: indexPath, animated: false)
      let question = survey.currentQuestion!
      let answer = question.answers[indexPath.row]
      question.select(answer: answer)
      tableView.reloadData()
      let currentCell = collectionView.cellForItem(at: IndexPath(row: survey.currentSequelIndex, section: 0)) as! SurveyCollectionViewCell
      if question.selectedAnswers.count > 0 {
        currentCell.rightButton.isEnabled = true
      } else {
        currentCell.rightButton.isEnabled = false
      }
    }
  }
}

extension SurveyViewController: NavigationButtonsCollectionViewCellDelegate {
  func rightButtonPressed() {
    guard let nextInSequel = survey.nextInSequel() else {
      dismiss(animated: true, completion: nil)
      return
    }
    switch nextInSequel {
    case .question:
      survey.questionAnswered()
      survey.nextQuestion()
    case .result:
      survey.questionAnswered()
    }
    collectionView.scrollToItem(at: IndexPath(row: survey.currentSequelIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
  }
  
  func leftButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
}
