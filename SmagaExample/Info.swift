//
//  Info.swift
//  SmagaExample
//
//  Created by grzesiek on 25/11/2016.
//  Copyright © 2016 Mateusz Mirkowski. All rights reserved.
//

import Foundation
import ObjectMapper

class Info: Mappable {
  
  var timestamp: String!
  var description: String?
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    timestamp <- map["timestamp"]
    description <- map["description"]
  }
  
}

