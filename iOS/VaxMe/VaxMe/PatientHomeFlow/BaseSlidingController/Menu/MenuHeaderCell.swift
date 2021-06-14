//
//  MenuHeaderCell.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import Kingfisher
import UIKit

enum MenuHeaderOption: Int {
    case Header
}

class MenuHeaderCell: UITableViewCell {
    
    // MARK: - UI COMPONENTS
    
    /// Profile Image View for Header
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    /// Stack View of user info
    lazy var tenantInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tenantName, viewProfileLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    /// Tenant's Name
    let tenantName: UILabel = {
        let label = UILabel()
        label.text = "Tenant Name"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .font(size: 16, weight: .bold, design: .default)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    /// Account Type Label
    let viewProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "View Profile"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .font(size: 12, weight: .regular, design: .default)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    // MARK: - INITIALIZATION
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         selectionStyle = .none
         contentView.backgroundColor = .systemBackground
         setupHeaderInfo()
         setupAutoLayout()
         setupProfileImageObserver()
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("profileImageObserver"), object: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Sets up the autolayout of the Header View
    private func setupAutoLayout() {
        self.backgroundColor = .systemBackground
        
        [userImageView, tenantInfoStackView].forEach { addSubview($0) }
        
                userImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.60)
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
        }
        
        tenantInfoStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(userImageView.snp.bottom).offset(5)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.25)
        }
    }
    
    /// Sets up a notification observer for profile image change
    fileprivate func setupProfileImageObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupHeaderInfo), name: NSNotification.Name(rawValue: "profileImageObserver"), object: nil)
    }
    
    /// Sets up the header info for slide menu header
    @objc func setupHeaderInfo() {
        //TODO: Samuel - Create a function to fetch user'a name and image
        //TODO: Ben - Improve the UI and default values while loading
//        guard let tenant = Tenant.current else { return }
//        // Fetches Tenant Name
//        TenantService.fetchTenantInfoContactInfo(userId: tenant.userId!) { (email, name, phoneNumber, countryCode, error) in
//            if error != nil {
//                print("Error Fetching Tenant Details")
//                return
//            }
//            self.tenantName.text = name
//        }
        self.tenantName.text = "User's Full name"
        
        // Fetches Tenant Profile Image
//        guard let user = Auth.auth().currentUser else { return }
//        guard let photoUrl = user.photoURL else { return }
//        userImageView.kf.setImage(with: photoUrl, placeholder: Constants.Images.defaultProfilePic, progressBlock: { receivedSize, totalSize in
//        }, completionHandler: { result in
//            do {
//                let _ = try result.get() //value
//            } catch {
//                DispatchQueue.main.async {
//                    print("Done downloading image")
//                }
//            }
//        })
    }
}
