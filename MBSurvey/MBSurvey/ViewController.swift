//
//  ViewController.swift
//  MBSurvey
//
//  Created by Mirko Babic on 5/22/17.
//  Copyright © 2017 Mirko Babic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBAction func startSurvey(_ sender: Any) {
    let url = URL(string: "http://devmobile.oroundocms.com/api/survey/all?poi_id=24&language_id=1")!
    Survey.getSurveyData(from: url) { (survey: Survey) in
      let storyboard = UIStoryboard(name: "Survey", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SurveyVC") as! SurveyViewController
      vc.survey = survey
      self.present(vc, animated: true, completion: nil)
    }
  }
}

