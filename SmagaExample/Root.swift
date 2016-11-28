//
//  Root.swift
//  SmagaExample
//
//  Created by grzesiek on 25/11/2016.
//  Copyright © 2016 Mateusz Mirkowski. All rights reserved.
//


import Foundation
import ObjectMapper

class Root: Mappable {
  
  var images: [Image]!
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    images <- map["images"]
  }
  
}
