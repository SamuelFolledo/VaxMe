//
//  Responses.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/14/21.
//

import Foundation

struct LogInResponse: Codable {
    private(set) var slug: String
    private(set) var token: String
    private(set) var expiresIn: String //Int in seconds
    private(set) var user: User
    
    func getAsPatient() -> Patient {
        let patient = Patient(logInResponse: self)
        return patient
    }
    
    struct User: Codable {
        var firstName: String
        var lastName: String
        var username: String
//        var passwordSha: String
    }
}

struct SignUpResponse: Codable {
//        var id: Int
//    private(set) var slug: String
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
        let patient = Patient(signUpResponse: self)
        return patient
    }
    
    struct User: Codable {
        var email: String
        var firstName: String
        var lastName: String
        var username: String
    }
}
