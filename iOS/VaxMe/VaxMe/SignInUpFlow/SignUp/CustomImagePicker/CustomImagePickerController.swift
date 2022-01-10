//
//  CustomImagePickerController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 9/20/20.
//  Copyright © 2020 Uchenna  Aguocha. All rights reserved.
//

import TLPhotoPicker

class CustomBlackStylePickerViewController: TLPhotosPickerViewController {
    override func makeUI() {
        super.makeUI()
        self.customNavItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: nil, action: #selector(customAction))
        self.view.backgroundColor = UIColor.red
        self.collectionView.backgroundColor = UIColor.yellow
        self.navigationBar.barStyle = .default
        self.titleLabel.textColor = .black
        self.subTitleLabel.textColor = .black
        self.navigationBar.tintColor = .systemPink
        self.popArrowImageView.image = TLBundle.podBundleImage(named: "pop_arrow")?.colorMask(color: .systemPink)
        self.albumPopView.popupView.backgroundColor = .white
        self.albumPopView.tableView.backgroundColor = .white
    }
    
    @objc func customAction() {
        self.delegate?.photoPickerDidCancel()
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.dismissComplete()
            self?.dismissCompletion?()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TLCollectionTableViewCell
        cell.backgroundColor = .white
        cell.titleLabel.textColor = .black
        cell.subTitleLabel.textColor = .black
        cell.tintColor = .black
        return cell
    }
}
