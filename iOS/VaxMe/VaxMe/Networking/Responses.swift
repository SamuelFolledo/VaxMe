//
//  Responses.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/14/21.
//

import Foundation

struct LogInResponse: Codable {
    private(set) var token: String
    private(set) var expiresIn: String //Int in seconds
    private(set) var user: User
    
    func getAsPatient() -> Patient {
        let patient = Patient(email: user.email, isSuperuser: false, username: user.username, firstName: user.firstName, lastName: user.lastName)
        return patient
    }
    
    struct User: Codable {
        var email: String
        var firstName: String
        var lastName: String
        var username: String
    }
}

struct SignUpResponse: Codable {
//        var id: Int
    private(set) var email: String
    private(set) var lastLogin: String? //optional on sign up and login
    private(set) var isSuperuser: Bool
    private(set) var username: String
    private(set) var groups: [String] = []
    private(set) var userPermissions: [String] = []
    private(set) var isStaff: Bool
    private(set) var isActive: Bool
    private(set) var dateJoined: String
//        var token: String
//        var expiresIn: String //Int in seconds
//        var user: User
    
    func getAsPatient() -> Patient {
        let patient = Patient(email: email, lastLogin: lastLogin, isSuperuser: isSuperuser, username: username, firstName: "", lastName: "", groups: groups, userPermissions: userPermissions, isStaff: isStaff, isActive: isActive, dateJoined: dateJoined)
        return patient
    }
    
    struct User: Codable {
        var email: String
        var firstName: String
        var lastName: String
        var username: String
    }
}
