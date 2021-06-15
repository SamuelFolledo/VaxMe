//
//  Constants.swift
//  StrepScan
//
//  Created by Samuel Folledo on 8/29/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum Constants {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    struct Views {
        //https://github.com/ninjaprox/NVActivityIndicatorView
        static var indicatorView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70), type: .ballClipRotateMultiple, color: UIColor.white.withAlphaComponent(0.75), padding: 0.0)
    }
    
    struct Images {
        //Views
        //Buttons
    }
    
    static let font: String = "BanglaSangamMN"
}

enum Keys {
    // Theme
    static var prefferedAccentColor = "prefferedAccentColor"
    static var isDark = "isDark"
    
    // URLs
//    static var baseURLPath = "http://localhost:8001/api"
    static var baseURLPath = "https://vaxmeapp.herokuapp.com/api/"
    static var publicDataURLPath = "\(Keys.baseURLPath)public/"
    static var logInURLPath = "\(Keys.baseURLPath)login/"
    static var signUpURLPath = "\(Keys.baseURLPath)signup/"
    static var userInfoURLPath = "\(Keys.baseURLPath)users/" //need "{userId/}"
    
    static var tokenExpiration = "tokenExpiration"
    static var tokenKey = "tokenKey"
    
    static let onboard = "onboard"
    //Customer
    static let currentUser = "currentUser"
    //Customer properties
    static let userId = "userId"
    static let name = "name"
    static let email = "email"
    static let username = "username"
}

enum AnimalKeys {
    static let id = "id"
    static let urlString = "urlString"
    static let name = "name"
    static let species = "species"
    static let breed = "breed"
    static let size = "size"
    static let age = "age"
    static let tags = "tags"
    static let attributes = "attributes"
    static let description = "description"
    static let photos = "photos"
    static let gender = "gender"
    static let status = "status"
    static let distance = "distance"
    static let shelterId = "shelterId"
    static let postedDate = "postedDate"
    static let contact = "contact"
}

extension AnimalKeys {
    enum Photos {
        static let smallPhoto = "smallPhoto"
        static let mediumPhoto = "mediumPhoto"
        static let largePhoto = "largePhoto"
        static let fullPhoto = "fullPhoto"
    }
    
    enum Contact {
        static let email = "email"
        static let phone = "phone"
        static let address = "address"
        
        enum Address {
            //TODO
            static let address1 = "address1"
            static let address2 = "address2"
            static let city = "city"
            static let state = "state"
            static let postcode = "postcode"
            static let country = "country"
        }
    }
}
