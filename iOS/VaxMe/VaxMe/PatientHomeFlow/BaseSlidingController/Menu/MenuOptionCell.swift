//
//  MenuOptionCell.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import UIKit

class MenuOptionCell: UITableViewCell {

    // MARK: - UI Components
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .font(size: 18, weight: .medium, design: .rounded)
        label.textAlignment = .left
        return label
    }()
    
    let counterLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.font = .font(size: 18, weight: .semibold, design: .rounded)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
        configureAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configureAutoLayout() {
        [iconImageView, descriptionLabel, counterLabel].forEach { contentView.addSubview($0) }
        
        iconImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(24)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.centerY.equalTo(contentView)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
        }
        
        counterLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel.snp.right).offset(15)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(30)
        }
    }
}
