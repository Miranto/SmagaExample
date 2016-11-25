//
//  CellData.swift
//  SmagaExample
//
//  Created by grzesiek on 25/11/2016.
//  Copyright © 2016 Mateusz Mirkowski. All rights reserved.
//

import Foundation
import ObjectMapper

class Image: Mappable {
  
  var imageURL: String!
  var info: Info!
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    imageURL <- map["imageURL"]
    info <- map["info"]
  }
  
}
