//
//  Endpoint.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/14/21.
//

import Foundation

struct EndPoint {
  var path: String
  var queryItems = [URLQueryItem]()
  
//  var urlString: String {
//    url?.absoluteString ?? "errorURL"
//  }
//
//  var url: URL? {
//    var components = URLComponents()
//    components.scheme = "https"
//    components.host = Keys.baseURLPath
//    components.path = path
//    components.queryItems = queryItems
//    return components.url
//  }
}


extension EndPoint {
    static var logInPath: Self {
        EndPoint(path: Keys.logInURLPath)
    }
    
    static var signUpPath: Self {
        EndPoint(path: Keys.signUpURLPath)
    }

    static var userInfoPath: Self {
        EndPoint(path: Keys.userInfoURLPath)
    }

    static var publicDataPath: Self {
        EndPoint(path: Keys.publicDataURLPath)
    }

//  static var tokenPath: Self {
//    EndPoint(path: Keys.tokenPath)
//  }
//
//  static func animals(queryItems : [URLQueryItem]) -> Self {
//    EndPoint(path: Keys.allAnimalsPath, queryItems: queryItems)
//  }
//
//  static func animals(from link: LinkString)  -> Self {
//    EndPoint(path: link.href)
//  }
//
//  static var typesPath: Self {
//    EndPoint(path: Keys.allTypesPath)
//  }
}
