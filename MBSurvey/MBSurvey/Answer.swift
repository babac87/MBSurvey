//
//  Answer.swift
//  MBSurvey
//
//  Created by Mirko Babic on 2/2/17.
//  Copyright © 2017 Happy Boar. All rights reserved.
//

import Foundation
import Unbox

class Answer: NSObject, Unboxable {
  
  var answer: String
  
  required init(unboxer: Unboxer) throws {
    answer = try unboxer.unbox(key: "text")
  }
  
  init(answer: String, correct: Bool) {
    self.answer = answer
  }
}
