//
//  MenuOption.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import UIKit


enum MenuOption: Int, CustomStringConvertible {
    
    case home, records, profile, scan, settings, logout
 
    
    var description: String {
        switch self {
        case .home: return "Home"
        case .records: return "Records"
        case .profile: return "Profile"
        case .scan: return "Scan"
        case .settings: return "Settings"
        case .logout: return "Log out"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home: return UIImage(systemName: "house.fill")!
        case .records: return UIImage(systemName: "folder.fill")!
        case .profile: return UIImage(systemName: "person.crop.square.fill")!
        case .scan: return UIImage(systemName: "camera.fill")!
        case .settings: return UIImage(systemName: "gearshape.fill")!
        case .logout: return UIImage(systemName: "figure.walk")!
        }
    }
}

extension MenuOption: CaseIterable {} //to turn cases to an array
