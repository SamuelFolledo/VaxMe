//
//  BaseSlidingController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import UIKit

class BaseSlidingController: UIViewController {
    
    // MARK: - Properties
    
    var rightViewLeadingConstraint: NSLayoutConstraint!
    var rightViewTrailingConstraint: NSLayoutConstraint!
    fileprivate let menuWidth: CGFloat = 300
    fileprivate let velocityThreshold: CGFloat = 500
    fileprivate var isMenuOpened = false
    
    // MARK: - UI Components
    
    let rightView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let leftView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let darkCoverView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var rightViewController: UIViewController = UINavigationController(rootViewController: HomeController())
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPanGesture()
    }
    
    // MARK: - @objc Selector Methods
    
    @objc fileprivate func handleTapDismiss() {
        closeMenu()
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var x = translation.x
        x = isMenuOpened ? x + menuWidth : x
        x = min(menuWidth, x)
        x = max(0, x)
        rightViewLeadingConstraint.constant = x
        rightViewTrailingConstraint.constant = x
        darkCoverView.alpha = x / menuWidth
        if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
    
    // MARK: - Public Methods
    
    func openMenu() {
        isMenuOpened = true
        rightViewLeadingConstraint.constant = menuWidth
        rightViewTrailingConstraint.constant = menuWidth
        performAnimations()
    }
    
    func closeMenu() {
        rightViewLeadingConstraint.constant = 0
        rightViewTrailingConstraint.constant = 0
        isMenuOpened = false
        performAnimations()
    }
    
    func didSelectHeaderOption(headerOption: MenuHeaderOption?) {
        performRightViewCleanUp()
        closeMenu()
        rightViewController = UINavigationController(rootViewController: ProfileController())
        addMiddleView()
    }

    
    func didSelectMenuOption(menuOption: MenuOption?) {
        guard let menuOption = menuOption else { return }
        performRightViewCleanUp()
        closeMenu()
        switch menuOption {
        case .home:
            rightViewController = UINavigationController(rootViewController: HomeController())
            addMiddleView()
        case .records:
            rightViewController = UINavigationController(rootViewController: RecordsController())
            addMiddleView()
        case .profile:
            rightViewController = UINavigationController(rootViewController: ProfileController())
            addMiddleView()
        case .scan:
            rightViewController = UINavigationController(rootViewController: ScanController())
            addMiddleView()
        case .settings:
            rightViewController = UINavigationController(rootViewController: SettingsController())
            addMiddleView()
        case .logout:
            rightViewController = UINavigationController(rootViewController: SettingsController())
            addMiddleView()
            showLogoutAlertView()
        }
    }
    
    private func addMiddleView() {
        rightView.addSubview(rightViewController.view)
        addChild(rightViewController)
        rightView.bringSubviewToFront(darkCoverView)
    }
    
    private func showLogoutAlertView() {
        let alert = UIAlertController(title: nil, message: "Do you want to logout?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logout = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            // Display signInController once the user signs out
//            if let _ = Tenant.current {
//                Tenant.removeCurrent(true)
//                UserDefaults.hasLoggedInOrCreatedAccount = false
                self.view.window?.rootViewController = UINavigationController(rootViewController: SignInController())
                self.view.window?.makeKeyAndVisible()
//            }
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Fileprivate Methods
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        if isMenuOpened {
            if velocity.x < -velocityThreshold {
                closeMenu()
                return
            }
            if abs(translation.x) < menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        } else {
            if velocity.x > velocityThreshold {
                openMenu()
                return
            }
            if translation.x < menuWidth / 2 {
                closeMenu()
            } else {
                openMenu()
            }
        }
    }
    
    fileprivate func performRightViewCleanUp() {
        rightViewController.view.removeFromSuperview()
        rightViewController.removeFromParent()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.isMenuOpened ? 1 : 0
        })
    }
    
    fileprivate func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        darkCoverView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(rightView)
        view.addSubview(leftView)
        // let's go ahead and use Auto Layout
        NSLayoutConstraint.activate([
            rightView.topAnchor.constraint(equalTo: view.topAnchor),
            rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftView.topAnchor.constraint(equalTo: view.topAnchor),
            leftView.trailingAnchor.constraint(equalTo: rightView.leadingAnchor),
            leftView.widthAnchor.constraint(equalToConstant: menuWidth),
            leftView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor)
        ])
        rightViewLeadingConstraint = rightView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        rightViewLeadingConstraint.isActive = true
        rightViewTrailingConstraint = rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        rightViewTrailingConstraint.isActive = true
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers() {
        let menuController = UINavigationController(rootViewController: MenuController())
        let homeView = rightViewController.view!
        let menuView = menuController.view!
        homeView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        rightView.addSubview(homeView)
        rightView.addSubview(darkCoverView)
        leftView.addSubview(menuView)
        NSLayoutConstraint.activate([
            // top, leading, bottom, trailing anchors
            homeView.topAnchor.constraint(equalTo: rightView.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
            homeView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor),
            homeView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
            menuView.topAnchor.constraint(equalTo: leftView.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: leftView.leadingAnchor),
            menuView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: leftView.trailingAnchor),
            darkCoverView.topAnchor.constraint(equalTo: rightView.topAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
            ])
        addChild(rightViewController)
        addChild(menuController)
    }
}
