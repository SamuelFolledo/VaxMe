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

//MARK: Methods
extension HomeController {
    func setupViews() {
        self.title = "Home"
    }
}
