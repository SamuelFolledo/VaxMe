//
//  ProfileImageView.swift
//  VaxMe
//
//  Created by Samuel Folledo on 7/17/21.
//

import Foundation
import SnapKit

class ProfileImageView: UIView {
    
    //MARK: Properties
    var isProfilePage: Bool
    
    // MARK: - UI Components
    
    let stackView = UIStackView(arrangedSubviews: [], axis: .vertical, alignment: .center, distribution: .fill, spacing: 16)
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let defaultImage = UIImage(systemName: "person.crop.circle")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        imageView.image = defaultImage
        imageView.backgroundColor = .systemBackground
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var changeProfileImageButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.clipsToBounds = true
        button.contentMode = .center
        let buttonImage = UIImage(systemName: "photo.fill.on.rectangle.fill")!.withTintColor(.systemBackground, renderingMode: .automatic)
        button.setImage(buttonImage.imageResize(sizeChange: CGSize(width: 20, height: 20)), for: .normal)
        button.backgroundColor = .systemPink
        return button
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .font(size: 24, weight: .bold, design: .default)
        label.text = "Name"
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initializers
    
    required init(isProfilePage: Bool) {
        self.isProfilePage = isProfilePage
        super.init(frame: .zero)
        configureAutoLayout()
    }
    
    override init(frame: CGRect) {
        self.isProfilePage = false
        super.init(frame: frame)
        configureAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = (containerView.frame.height * 0.75) / 2.0
        changeProfileImageButton.layer.cornerRadius = 15
    }
    
    // MARK: - Methods
    
    private func configureAutoLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(self.snp.height).multipliedBy(0.85)
            $0.width.equalToSuperview()
        }
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        [userImageView, nameLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        userImageView.snp.makeConstraints {
            $0.width.height.equalTo(containerView.snp.height).multipliedBy(0.8)
        }
        nameLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        if isProfilePage { //only show changeProfileImageButton if it's on profile page
            containerView.addSubview(changeProfileImageButton)
            changeProfileImageButton.snp.makeConstraints {
                $0.width.height.equalTo(35)
                $0.right.bottom.equalTo(userImageView)
            }
        }
    }
}
