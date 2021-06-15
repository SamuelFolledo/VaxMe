//
//  Patient.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/14/21.
//

import Foundation

struct Patient: Codable {
//        var id: Int
    var email: String
    var lastLogin: String? //optional on sign up and login
    var isSuperuser: Bool
    var username: String
    var firstName: String
    var lastName: String
    var groups: [String] = []
    var userPermissions: [String] = []
    var isStaff: Bool? //currently not optional when sign up
    var isActive: Bool? //currently not optional when sign up
    var dateJoined: String? //currently not optional when sign up
}
