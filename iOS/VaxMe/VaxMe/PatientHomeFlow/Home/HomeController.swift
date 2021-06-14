//
//  HomeController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import SnapKit

class HomeController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Views
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: Setup Methods
extension HomeController {
    private func setupViews() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Home"
        let buttonImage = UIImage(systemName: "line.horizontal.3")!.withRenderingMode(.alwaysOriginal)
        let barButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(handleOpenMenu))
        navigationItem.leftBarButtonItem = barButton
    }
    
    // MARK: - @objc Methods
    
    @objc private func handleOpenMenu() {
        guard let slidingController = UIWindow.key?.rootViewController as? BaseSlidingController else { return }
        slidingController.openMenu()
    }
}
