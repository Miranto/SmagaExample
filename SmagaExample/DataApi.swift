//
//  DataApi.swift
//  SmagaExample
//
//  Created by grzesiek on 25/11/2016.
//  Copyright © 2016 Mateusz Mirkowski. All rights reserved.
//


import Foundation
import Moya

enum DataApi {
  case imagesList
}

extension DataApi: TargetType {
  var baseURL: URL { return URL(string: "https://dl.dropboxusercontent.com")! }
  var path: String {
    switch self {
    case .imagesList:
      return "/u/16049878/images/test.json"
    }
  }
  var method: Moya.Method {
    switch self {
    case .imagesList:
      return .get
    }
    
  }
  var parameters: [String : Any]? {
    switch self {
    case .imagesList:
      return nil
    }
  }
  var sampleData: Data {
    switch self {
    case .imagesList:
      return "Test data".utf8EncodedData
    }
  }
  var task: Task {
    switch self {
    case .imagesList:
      return .request
    }
  }
}

// MARK: - Helpers
private extension String {
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
  
  var utf8EncodedData: Data {
    return self.data(using: .utf8)!
  }
}
