//
//  Patient.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/14/21.
//

import Foundation

struct Patient: Codable {
//        var id: Int
    var slug: String
    var email: String?
    var lastLogin: String? //optional on sign up and login
    var isSuperuser: Bool
    var username: String
    var firstName: String?
    var lastName: String?
    var groups: [String] = []
    var userPermissions: [String] = []
    var isStaff: Bool? //currently not optional when sign up
    var isActive: Bool? //currently not optional when sign up
    var dateJoined: String? //currently not optional when sign up
    var dob: String?
    var zip: String?
    
    //MARK: Singleton
    private static var _current: Patient?
    
    static var current: Patient? {
        // Check if current user (tenant) exist
        if let currentUser = _current {
            return currentUser
        } else {
            // Check if the user was saved in UserDefaults. If not, return nil
            guard let user = UserDefaults.standard.getStruct(Patient.self, forKey: Keys.currentUser) else { return nil }
            _current = user
            return user
        }
    }
    
    init(logInResponse: LogInResponse) {
        self.slug = logInResponse.slug
        let user = logInResponse.user
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.username = user.username
        self.isSuperuser = false
    }
    
    init(signUpResponse: SignUpResponse) {
//        self.slug = signUpResponse.slug
        self.slug = ""
        self.email = signUpResponse.email
        self.lastLogin = signUpResponse.lastLogin
        self.isSuperuser = signUpResponse.isSuperuser
        self.username = signUpResponse.username
        self.groups = signUpResponse.groups
        self.userPermissions = signUpResponse.userPermissions
        self.isStaff = signUpResponse.isStaff
        self.isActive = signUpResponse.isActive
        self.dateJoined = signUpResponse.dateJoined
    }
}

// MARK: - Static Methods
extension Patient {
    static func setCurrent(_ user: Patient, writeToUserDefaults: Bool = false) {
        // Save user's information in UserDefaults excluding passwords and sensitive (private) info
        if writeToUserDefaults {
            UserDefaults.standard.setStruct(user, forKey: Keys.currentUser)
        }
        _current = user
    }
    
    static func removeCurrent(_ removeFromUserDefaults: Bool = false) {
        if removeFromUserDefaults {
            Defaults._removeUser(true)
        }
        _current = nil
    }
}

