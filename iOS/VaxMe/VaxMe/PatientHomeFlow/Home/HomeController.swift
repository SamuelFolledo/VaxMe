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
    let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "qr.png")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .font(size: 20, weight: .bold, design: .default)
        label.textColor = .label
        label.text = "Theresa Peterson"
        label.sizeToFit()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    lazy var dobLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .font(size: 16, weight: .regular, design: .default)
        label.textColor = .label
        label.sizeToFit()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "DOB: 06/05/1995"
        return label
    }()
    let covidLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .font(size: 20, weight: .bold, design: .default)
        label.textColor = .label
        label.sizeToFit()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "COVID-19 VACCINATION"
        return label
    }()
    let viewVaccinationButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Vaccination", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(size: 20, weight: .bold, design: .rounded)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(viewVaccinationButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        let stackView = UIStackView(axis: .vertical, spacing: 16, distribution: .fill, alignment: .center)
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-8)
        }
        [qrImageView, nameLabel, dobLabel, covidLabel, viewVaccinationButton].forEach {
            stackView.addArrangedSubview($0)
        }
        qrImageView.snp.makeConstraints {
            $0.width.height.equalTo(stackView.snp.width).multipliedBy(0.8)
        }
        viewVaccinationButton.snp.makeConstraints {
            $0.width.equalTo(qrImageView.snp.width)
            $0.height.equalTo(40)
        }
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
    
    @objc func viewVaccinationButtonTapped() {
        print("TODO: View vaccination")
    }
}
