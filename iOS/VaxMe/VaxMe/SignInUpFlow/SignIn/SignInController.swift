//
//  SignInController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import SnapKit

/*
 TODO #1
 [] Build UI
 [] Save that orange/pink color to UIColor+Extensions (get the hex/rgb from Vlad)
 [] Use String+Extensions.swift (not sure if it still works) to update the email and password validator. If both email and passwords are valid, then enable the Sign In button
 [] Clean texts for email, names, etc. (e.g. email should not have whitespace at the beginning and end)
 [] Create the Forgot Password Controller and push it when button is tapped
 [] Eye thing on password to show and unshow the password
 */


class SignInController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Views
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: Methods
extension SignInController {
    func setupViews() {
        self.title = "Sign In"
    }
}
