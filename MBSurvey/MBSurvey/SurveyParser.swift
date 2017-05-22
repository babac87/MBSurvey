//
//  SurveyParser.swift
//  MBSurvey
//
//  Created by Mirko Babic on 3/13/17.
//  Copyright © 2017 Happy Boar. All rights reserved.
//

import Foundation
import Unbox

class SurveyParser: NSObject {
  static func getData(fromURL url: URL, completion: @escaping (Survey) -> ()) {
    URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
      if let error = error {
        print(error)
      } else {
        // "Surveys" should be fixed on backend
        let surveys = try! unbox(data: data!) as [Survey]
        DispatchQueue.main.sync {
          completion(surveys.first!)
        }
      }
    }.resume()
  }
}
