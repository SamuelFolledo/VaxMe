//
//  ProfileController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import SnapKit

class ProfileController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Views
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: Methods
extension ProfileController {
    func setupViews() {
        self.title = "Profile"
    }
}
