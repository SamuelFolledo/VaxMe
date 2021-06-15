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
 [] Eye thing on password to show and unshow the password
 [] Also create the view when Terms of Services and Privacy Policy is tapped
 */


class SignUpController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Views
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "Enter email"
        let placeHolder = NSAttributedString(string: "Enter email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
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
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "Enter username"
        let placeHolder = NSAttributedString(string: "Enter username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.attributedPlaceholder = placeHolder
        textField.font = .font(size: 18, weight: .medium, design: .rounded)
        textField.textColor = .black
        textField.backgroundColor = UIColor(r: 242, g: 242, b: 242, a: 1)
        textField.setPadding(left: 15, right: 15)
        textField.layer.cornerRadius = 10
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.keyboardType = .default
        textField.autocapitalizationType = .words
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
    
    lazy var password2TextField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "Retype password"
        let placeHolder = NSAttributedString(string: "Retype password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
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
    
    var iAgreeToLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .font(size: 12, weight: .regular, design: .default)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "## TODO: with check button for. I agree to Terms of Services and Privacy Poicy"
        return label
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.frame = CGRect(x: 0, y: 0, width: 85, height: 45)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemPink
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.frame = CGRect(x: 0, y: 0, width: 85, height: 45)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.setTitleColor(.systemPink, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
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
        APIService.signUp(email: emailTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!, password2: password2TextField.text!) { result in
            switch result {
            case .failure(let error):
                print("Error signing up \(error.localizedDescription)")
            case .success(let patient):
                print("GOTTT PATIENT \(patient)")
                Patient.setCurrent(patient, writeToUserDefaults: true)
                DispatchQueue.main.async {
                    self.view.window?.rootViewController = BaseSlidingController()
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    @objc func signInButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
