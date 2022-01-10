//
//  SignUpController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import SnapKit

/*
 TODO - Ben #2
 [] Build UI
    [] hide/unhide password for password and password2 textfields
    [] put the stack of textfields in its own view subclass to make it clean and keep VC short (e.g. name is AuthFormView)
    [] Use AppService to create these textfields and other views to allow reusability
 [] Save that orange/pink color to UIColor+Extensions (get the hex/rgb from Vlad)
 [] Use String+Extensions.swift (not sure if it still works) to update the email and password validator. If both email and passwords are valid, then enable the Sign In button
 [] Clean texts for email, names, etc. (e.g. email should not have whitespace at the beginning and end)
 [] Show activity indicators when sign up loading
 [] Eye thing on password textfield to show and unshow the password
 [] Also create the view when Terms of Services and Privacy Policy is tapped
*/

class SignUpController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Views
    
    lazy var emailTextField: UITextField = {
        return AppService.createTextField(type: .email)
    }()
    
    lazy var usernameTextField: UITextField = {
        return AppService.createTextField(type: .username)
    }()
    
    lazy var passwordTextField: UITextField = {
        return AppService.createTextField(type: .password)
    }()
    
    lazy var password2TextField: UITextField = {
        return AppService.createTextField(type: .password2)
    }()
    
    var iAgreeToLabel: UILabel = {
        let text = "## TODO: with check button for. I agree to Terms of Services and Privacy Poicy"
        let label = AppService.createLabel(type: .small(text: text))
        return label
    }()
    
    lazy var continueButton: UIButton = {
        let buttonTitle = "Continue"
        let button = AppService.createButton(type: .primaryButton(title: buttonTitle))
        button.addTarget(self, action: #selector(self.continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var signInButton: UIButton = {
        let buttonTitle = "Already have an account?"
        let button = AppService.createButton(type: .secondaryButton(title: buttonTitle))
        button.addTarget(self, action: #selector(self.signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: Methods
extension SignUpController {
    func setupViews() {
        hideKeyboardOnTap()
        self.title = "Sign Up"
        view.backgroundColor = .systemBackground
        let stackView = UIStackView(axis: .vertical, spacing: 16, distribution: .fill, alignment: .center)
        view.addSubview(stackView)
        emailTextField.text = "samuelfolledo@gmail.com"
        passwordTextField.text = "PassMe123"
        password2TextField.text = "PassMe123"
        usernameTextField.text = "Samuel"
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-32)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        [emailTextField, usernameTextField, passwordTextField, password2TextField, iAgreeToLabel, continueButton, signInButton
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints{
                $0.width.equalToSuperview()
            }
        }
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        usernameTextField.snp.makeConstraints {
            $0.height.equalTo(emailTextField.snp.height)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(emailTextField.snp.height)
        }
        password2TextField.snp.makeConstraints {
            $0.height.equalTo(emailTextField.snp.height)
        }
        continueButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        signInButton.snp.makeConstraints {
            $0.height.equalTo(continueButton.snp.height)
        }
    }
    
    //MARK: @OBJC func
    @objc func continueButtonTapped() {
        guard let email = emailTextField.text,
              let username = usernameTextField.text,
              let password1 = passwordTextField.text,
              let password2 = password2TextField.text
        else { return }
        APIService.signUp(email: email, username: username, password: password1, password2: password2) { result in
            switch result {
            case .failure(let error):
                print("Error signing up \(error.localizedDescription)")
            case .success(let patient):
                print("GOTTT PATIENT \(patient)")
                var updatedPatient = patient
                updatedPatient.email = email
                Patient.setCurrent(updatedPatient, writeToUserDefaults: true) //TODO: Do not set patient until finish sign up controller is done
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(FinishSignUpViewController(), animated: true)
                }
            }
        }
    }
    
    @objc func signInButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
