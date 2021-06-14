//
//  AppService.swift
//  StrepScan
//
//  Created by Samuel Folledo on 8/29/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
//import SkyFloatingLabelTextField

struct AppService {
    
    ///generate randomString
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

//MARK: - Buttons
extension AppService {
    enum ButtonType {
        case share, savePhotos, `continue`, grayButton(title: String), roundedGrayButton(image: UIImage?)
    }
    
    static func createButton(type: ButtonType) -> UIButton {
        switch type {
        case .share:
            return createShareButton()
        case .savePhotos:
            return createSavePhotosButton()
        case .continue:
            return createContinueButton()
        case .grayButton(let title):
            return createGrayButton(title: title)
        case .roundedGrayButton(let image):
            return createRoundedGrayButton(image: image)
        }
    }
    
    private static func createRoundedGrayButton(image: UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.clipsToBounds = true
        return button
    }
    
    private static func createGrayButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle("\(title)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold) //UIFont(name: YourfontName, size: 20)
        button.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return button
    }
    
    private static func createShareButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .strepScanDarkBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Share", for: .normal)
        return button
    }
    
    private static func createSavePhotosButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .strepScanDarkBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Save Photos", for: .normal)
        return button
    }
    
    private static func createContinueButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .strepScanDarkBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Continue", for: .normal)
        return button
    }
    
    
}

//MARK: - Labels
extension AppService {
    static func defaultLabel(weight: UIFont.Weight = .regular) -> UILabel {
        let label = UILabel()
        label.font = .font(size: 20, weight: weight, design: .default)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }
}

//MARK: Textfields
//extension AppService {
//    ///returns the app's textfield for names
//    static func firstNameTextField() -> SkyFloatingLabelTextField {
//        let textField = AppService.textField(title: "First Name", placeHolder: "Enter first name")
//        textField.textColor = .black
//        textField.layer.cornerRadius = 10
//        textField.textAlignment = .left
//        textField.returnKeyType = .continue
//        textField.autocapitalizationType = .words
//        return textField
//    }
//    
//    static func lastNameTextField() -> SkyFloatingLabelTextField {
//        let textField = AppService.textField(title: "Last Name", placeHolder: "Enter last name")
//        textField.textColor = .black
//        textField.layer.cornerRadius = 10
//        textField.textAlignment = .left
//        textField.returnKeyType = .continue
//        textField.autocapitalizationType = .words
//        return textField
//    }
//    
//    ///returns the app's textfield for email
//    static func emailTextField() -> SkyFloatingLabelTextField {
//        let textField = AppService.textField(title: "Email", placeHolder: "Enter email")
//        textField.textColor = .label
//        textField.layer.cornerRadius = 10
//        textField.textAlignment = .left
//        textField.returnKeyType = .continue
//        textField.keyboardType = .emailAddress
//        textField.autocapitalizationType = .none
//        return textField
//    }
//    
//    ///returns the app's textfield for password
//    static func passwordTextField() -> SkyFloatingLabelTextField {
//        let textField = AppService.textField(title: "Password", placeHolder: "Enter password")
//        textField.layer.cornerRadius = 10
//        textField.textColor = .label
//        textField.textAlignment = .left
//        textField.returnKeyType = .done
//        textField.isSecureTextEntry = true
////        textField.textContentType = .password
//        return textField
//    }
//    
//    static func dateOfBirthTextField() -> SkyFloatingLabelTextField {
//        let textField = AppService.textField(title: "Date Of Birth (MM/DD/YYYY)", placeHolder: "Enter birthday (MM/DD/YYYY)")
//        textField.textColor = .black
//        textField.layer.cornerRadius = 10
//        textField.textAlignment = .left
//        textField.returnKeyType = .continue
//        textField.autocapitalizationType = .words
//        textField.keyboardType = .numberPad
//        return textField
//    }
//    
//    static func genderTextField() -> SkyFloatingLabelTextField {
//        let textField = AppService.textField(title: "Gender", placeHolder: "Select gender")
//        textField.textColor = .black
//        textField.layer.cornerRadius = 10
//        textField.textAlignment = .left
//        textField.returnKeyType = .continue
//        textField.autocapitalizationType = .words
//        return textField
//    }
//    
//    static func textField(title: String, placeHolder: String) -> SkyFloatingLabelTextField {
//        let textField = SkyFloatingLabelTextField(frame: .zero)
//        textField.titleFont = .font(size: 18, weight: .medium, design: .rounded)
//        textField.font = .font(size: 18, weight: .medium, design: .rounded)
//        textField.placeholder = placeHolder
//        textField.title = title
//        textField.tintColor = .strepScanNeutralBlue
//        textField.selectedTitleColor = .strepScanNeutralBlue
//        textField.selectedLineColor = .strepScanNeutralBlue
//        textField.lineHeight = 1.0 // bottom line height in points
//        textField.selectedLineHeight = 2.0
//        return textField
//    }
//}
