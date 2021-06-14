//
//  MenuController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import SnapKit

class MenuController: UIViewController {
    
    // MARK: - Properties
//    private let headerReuseIdentifier = "MenuHeaderCell"
//    private let reuseIdentifier = "MenuOptionCell"
    
    // MARK: - UI Components
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuHeaderCell.self, forCellReuseIdentifier: String(describing: MenuHeaderCell.self))
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: String(describing: MenuOptionCell.self))
        tableView.allowsSelection = true
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        return tableView
    }()
    
    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureTableView()
        setupUnreadChatsObserver()
    }
    
    fileprivate func setupUnreadChatsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(unreadChatsUpdated(_:)), name: Notification.Name("unreadChatsObserver"), object: nil)
    }
    
    @objc func unreadChatsUpdated(_ notification:Notification) {
        tableView.reloadData()
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: Notification.Name("unreadChatsObserver"), object: nil)
    }
    
    // MARK:- Methods
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        navigationItem.title = "Menu"
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
        }
    }
    
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return MenuOption.allCases.count
        default:
            return MenuOption.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuHeaderCell.self), for: indexPath) as! MenuHeaderCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuOptionCell.self), for: indexPath) as! MenuOptionCell
            
            let menuOption = MenuOption.allCases[indexPath.row]
            cell.descriptionLabel.text = menuOption.description
            cell.iconImageView.image = menuOption.image
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 140
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let headerOption = MenuHeaderOption(rawValue: indexPath.row)
            // Highlights selected Cell
            if let cell = tableView.cellForRow(at: indexPath) as? MenuHeaderCell {
                // If the header view is tapped, change the color
                cell.contentView.backgroundColor = .systemBackground
            }
            guard let slidingController =
                    UIWindow.key?.rootViewController as? BaseSlidingController else { return }
            slidingController.didSelectHeaderOption(headerOption: headerOption)
        case 1:
            let menuOption = MenuOption(rawValue: indexPath.row)
            // Highlights selected Cell
            if let cell = tableView.cellForRow(at: indexPath) as? MenuOptionCell {
                cell.contentView.backgroundColor = .lightGray
            }
            guard let slidingController = UIWindow.key?.rootViewController as? BaseSlidingController else { return }
            slidingController.didSelectMenuOption(menuOption: menuOption)
        default:
            return
        }
    }
    
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // Un-Highlights selected Cell
            if let cell = tableView.cellForRow(at: indexPath) as? MenuHeaderCell {
                cell.contentView.backgroundColor = .systemBackground
            }
        case 1:
            // Un-Highlights selected Cell
            if let cell = tableView.cellForRow(at: indexPath) as? MenuOptionCell {
                cell.contentView.backgroundColor = .systemBackground
            }
        default:
            return
        }
    }
}




