//
//  DescriptionCollectionViewCell.swift
//  MBSurvey
//
//  Created by Mirko Babic on 2/6/17.
//  Copyright © 2017 Happy Boar. All rights reserved.
//

import UIKit

class DescriptionCollectionViewCell: SurveyCollectionViewCell {
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    correctImageView.round()
  }
  
  @IBOutlet weak var correctImageView: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!
  
}
