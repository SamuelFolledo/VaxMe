//
//  FinishSignUpViewController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 7/16/21.
//

import SnapKit
//For Photos
import TLPhotoPicker
import Photos
import Kingfisher

/*
 - image, first name, last name, dob, email, zip, //username
 */

class FinishSignUpViewController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Views
    lazy var firstNameTextfield: UITextField = {
        return AppService.createTextField(type: .firstName)
    }()
    
    lazy var lastNameTextField: UITextField = {
        return AppService.createTextField(type: .lastName)
    }()
    
    lazy var dobTextfield: UITextField = {
        let textField = AppService.createTextField(type: .dob)
        return textField
    }()
    
    lazy var zipTextField: UITextField = {
        return AppService.createTextField(type: .zip)
    }()
    
    lazy var finishSignUpButton: UIButton = {
        let buttonTitle = "Complete"
        let button = AppService.createButton(type: .primaryButton(title: buttonTitle))
        button.addTarget(self, action: #selector(finishSignUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var imagePickerController: CustomBlackStylePickerViewController = {
        let imagePickerController = CustomBlackStylePickerViewController()
        imagePickerController.delegate = self
        imagePickerController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            print("Reached limit \(picker)")
        }
        var configure = TLPhotosPickerConfigure()
        configure.tapHereToChange = "Tap here to change album"
        configure.numberOfColumn = 3
        configure.previewAtForceTouch = true
        configure.allowedPhotograph = true
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        configure.autoPlay = true
        configure.maxSelectedAssets = 1
        configure.singleSelectedMode = true
        imagePickerController.configure = configure
        return imagePickerController
    }()
    
    lazy var userImageView: ProfileImageView = {
        let imageView = ProfileImageView(isProfilePage: true)
        imageView.changeProfileImageButton.addTarget(self, action: #selector(self.changeProfileImageTapped), for: .touchUpInside)
        return imageView
    }()
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.changeProfileImageButton.removeOuterBorders()
        userImageView.changeProfileImageButton.addOuterRoundedBorder(borderWidth: 4, borderColor: .systemBackground)
    }
}

//MARK: Methods
extension FinishSignUpViewController {
    func setupViews() {
        hideKeyboardOnTap()
        self.title = "Finish Signing Up"
        view.backgroundColor = .systemBackground
        let stackView = UIStackView(axis: .vertical, spacing: 16, distribution: .fill, alignment: .center)
        view.addSubview(stackView)
        firstNameTextfield.text = "Samuel"
        lastNameTextField.text = "Folledo"
        dobTextfield.text = "1995-10-07"
        zipTextField.text = "07306"
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-32)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        [userImageView, firstNameTextfield, lastNameTextField, dobTextfield, zipTextField, finishSignUpButton
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(30)
                $0.width.equalToSuperview()
            }
        }
        userImageView.snp.makeConstraints {
            $0.height.equalTo(view.snp.height).multipliedBy(0.35)
        }
        finishSignUpButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    //MARK: @OBJC func
    @objc func finishSignUpButtonTapped() {
        guard let firstName = firstNameTextfield.text,
              let lastName = lastNameTextField.text,
              let dob = dobTextfield.text,
              let zip = zipTextField.text,
              let image = userImageView.userImageView.image
        else { return }
        APIService.finishSigningUp(firstName: firstName,
                                   lastName: lastName,
                                   dob: dob,
                                   zip: zip,
                                   image: image) { error in
            if let error = error {
                print("Error finish sign up \(error)")
                return
            }
            guard var patient = Patient.current else { return } //todo refactor
            patient.firstName = firstName
            patient.lastName = lastName
            patient.dob = dob
            patient.zip = zip
            Patient.setCurrent(patient, writeToUserDefaults: true)
            DispatchQueue.main.async {
                self.view.window?.rootViewController = BaseSlidingController()
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}

//MARK: ImagePicker
extension FinishSignUpViewController {
    @objc func changeProfileImageTapped() {
        //check if app has permission (or was changed)
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: //if app is authorized, showImagePicker
            DispatchQueue.main.async {
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        case .denied, .restricted:
            self.presentAlert(title: "Access Photo Denied", message: "VaxMe has been denied access to your photos. To change this, please go to your Settings and try again.")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in // ask for permissions
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.present(self.imagePickerController, animated: true, completion: nil)
                    }
                case .denied, .restricted:
                    self.presentAlert(title: "Access Photo Denied", message: "VaxMe has been denied access to your photos. To change this, please go to your Settings and try again.")
                default: break
                }
            }
        default: break
        }
    }
    
    ///upload chat's image to Storage and returns the downloadUrl
//    fileprivate func uploadImage(image: UIImage, completion: @escaping (_ downloadUrl: URL?, _ error: String?) -> Void) {
//        let resizedImage: UIImage
//        if let imageResized = image.resized(toWidth: 1000) {
//            resizedImage = imageResized
//        } else if let imageResized = image.resized(withPercentage: 0.5) {
//            resizedImage = imageResized
//        } else {
//            resizedImage = image
//        }
//        let imageData = resizedImage.pngData()
//
//    }
}

//MARK: TLPhotos Delegate
extension FinishSignUpViewController: TLPhotosPickerViewControllerDelegate {
    
}

//MARK: TLPhotos Helpers
extension FinishSignUpViewController {
    
    ///photos and videos after dismissing the image picker controller
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if let asset = withTLPHAssets.first {
            if asset.type == .photo {
                if let image = asset.fullResolutionImage {
                    self.userImageView.userImageView.image = image
//                    self.uploadImage(image: image, url: "profileImages/\(user.uid)") { (url, error) in
//                        if let error = error {
//                            self.presentAlert(title: "Error Uploading Image", message: error)
//                            return
//                        }
//                        guard let photoUrl = url else { return }
//                        //update user's photoURL stored
//                        let request = user.createProfileChangeRequest()
//                        request.photoURL = photoUrl
//                        request.commitChanges { (error) in
//                            if let error = error {
//                                self.presentAlert(title: "Error Updating Photo URL", message: error.localizedDescription)
//                                return
//                            }
//                            print("Successfully updated user's photoURL \(photoUrl.absoluteString)")
//                            // Changes the profile picture in the slide menu
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileImageObserver"), object: nil)
//                        }
//                    }
                } else {
                    print("No image")
                }
            } else {
                self.presentAlert(title: "Media type unsupported")
            }
        }
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let alert = UIAlertController(title: "", message: "Denied albums permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "", message: "Denied camera permissions granted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }
}
