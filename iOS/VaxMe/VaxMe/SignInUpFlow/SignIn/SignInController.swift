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
 [] Show activity indicators when loggin in
 [] Create the Forgot Password Controller and push it when button is tapped
 [] Eye thing on password to show and unshow the password
 */


class SignInController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Views
    
    lazy var usernameTextfield: UITextField = {
        return AppService.createTextField(type: .username)
    }()
    
    lazy var passwordTextField: UITextField = {
        return AppService.createTextField(type: .password)
    }()
    
    lazy var signInButton: UIButton = {
        let buttonTitle = "Sign In"
        let button = AppService.createButton(type: .primaryButton(title: buttonTitle))
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var socialProfilesLabel: UILabel = {
        let text = "## TODO: for \"or use one of your social profiles\""
        let label = AppService.createLabel(type: .small(text: text))
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let buttonTitle = "No account? Create here"
        let button = AppService.createButton(type: .secondaryButton(title: buttonTitle))
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
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
        usernameTextfield.text = "admin"
        passwordTextField.text = "ad"
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
        APIService.signIn(username: usernameTextfield.text!, password: passwordTextField.text!) { result in
            switch result {
            case .failure(let error):
                print("Error signin In \(error.localizedDescription)")
            case .success(let patient):
                print("Signed in patient: \(patient)")
                Patient.setCurrent(patient, writeToUserDefaults: true)
                DispatchQueue.main.async {
                    self.view.window?.rootViewController = BaseSlidingController()
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    @objc func signUpButtonTapped() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
}
