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
    
    lazy var usernameTextfield: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "Enter email"
        let placeHolder = NSAttributedString(string: "Enter username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.attributedPlaceholder = placeHolder
        textField.font = .font(size: 18, weight: .medium, design: .rounded)
        textField.textColor = .black
        textField.backgroundColor = UIColor(r: 242, g: 242, b: 242, a: 1)
        textField.setPadding(left: 15, right: 15)
        textField.layer.cornerRadius = 10
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.tintColor = .systemPink
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "Password"
        let placeHolder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.attributedPlaceholder = placeHolder
        textField.font = .font(size: 18, weight: .medium, design: .rounded)
        textField.textColor = .black
        textField.backgroundColor = UIColor(r: 242, g: 242, b: 242, a: 1)
        textField.setPadding(left: 15, right: 15)
        textField.layer.cornerRadius = 10
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.keyboardType = .default
        textField.isSecureTextEntry = true //TODO: - Ben Set this base on the Hide and Unhide feature
        textField.autocapitalizationType = .none
        textField.tintColor = .systemPink
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.frame = CGRect(x: 0, y: 0, width: 85, height: 45)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemPink
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var socialProfilesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .font(size: 12, weight: .regular, design: .default)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "## TODO: for \"or use one of your social profiles\""
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.frame = CGRect(x: 0, y: 0, width: 85, height: 45)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.setTitleColor(.systemPink, for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        //add border
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemPink.withAlphaComponent(0.9).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.clipsToBounds = true
        return button
    }()
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: Methods
extension SignInController {
    func setupViews() {
        hideKeyboardOnTap()
        self.title = "Sign In"
        view.backgroundColor = .systemBackground
        let stackView = UIStackView(axis: .vertical, spacing: 16, distribution: .fill, alignment: .center)
        view.addSubview(stackView)
        usernameTextfield.text = "Samuel"
        passwordTextField.text = "PassMe123"
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-32)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        [usernameTextfield, passwordTextField, signInButton, socialProfilesLabel, signUpButton
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints{
                $0.width.equalToSuperview()
            }
        }
        usernameTextfield.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(usernameTextfield.snp.height)
        }
        signInButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(signInButton.snp.height)
        }
    }
    
    //MARK: @OBJC func
    @objc func signInButtonTapped() {
        //MARK: - TODO - Ben Clean email and other texts here
        print("Continue Sign In todo - Samuel")
        APIService.signIn(username: usernameTextfield.text!, password: passwordTextField.text!) { result in
            switch result {
            case .failure(let error):
                print("Error signin In \(error.localizedDescription)")
            case .success(let patient):
                print("Got patient!!! \(patient)")
            }
        }
//        APIService.signUp(email: usernameTextfield.text!, username: usernameTextField.text!, password: passwordTextField.text!, password2: password2TextField.text!) { result in
//            switch result {
//            case .failure(let error):
//                print("Error signing up \(error.localizedDescription)")
//            case .success(let patient):
//                print("GOTTT PATIENT")
//            }
//        }
    }
    
    @objc func signUpButtonTapped() {
//        dismiss(animated: true, completion: nil)
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
}
