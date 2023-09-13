//
//  SettingsVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 31.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

protocol ReturnToSettings: AnyObject {
    func returned(message: String)
}

class SettingsVC: UIViewController {
    
    let viewModel = SettingsVM()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.tintColor = AppColor.backgroundDark.colorValue()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 60
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.backgroundDark.colorValue()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 16)
        return label
    }()

    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 12)
        button.setTitleColor(AppColor.secondaryColor.colorValue(), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = AppColor.primaryColor.colorValue()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16)
        collectionView.register(SettingsCVC.self, forCellWithReuseIdentifier: SettingsCVC.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupApi()
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.deleteAccessToken {
            let vc = LoginVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func didTapEditProfileButton() {
        let vc = EditProfileVC()
        vc.user = viewModel.userInfos
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func configure() {
        guard let user = viewModel.userInfos,
              let imageURL = user.pp_url,
              let url = URL(string: imageURL),
              let name = user.full_name else {
            self.profileImageView.image = UIImage(named: "person.fill")
            return
        }
        self.nameLabel.text = name
        
        loadImageWithActivityIndicator(from: url, indicator: activityIndicator, into: profileImageView)
    }
    
    private func setupApi() {
        viewModel.getUserInfos() { status in
            if status {
                self.configure()
            } else {
                self.showAlert(title: "Error!", message: "User information could not be found. Please try again.")
            }
        }
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(titleLabel,
                              logoutButton,
                              mainView)
        self.mainView.addSubviews(profileImageView,
                                  activityIndicator,
                                  nameLabel,
                                  editProfileButton,
                                  collectionView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.width.equalTo(30)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(54)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(62)
            make.height.equalTo(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension SettingsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 54)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = indexPath.item
        var destinationVC: UIViewController?
        
        switch selectedItem {
        case 0:
            let vc = SecuritySettingsVC()
            vc.delegate = self
            destinationVC = vc
            destinationVC?.hidesBottomBarWhenPushed = true
        case 2:
            destinationVC = MyAddedPlacesVC()
            destinationVC?.hidesBottomBarWhenPushed = true
        case 3:
            destinationVC = HelpSupportVC()
            destinationVC?.hidesBottomBarWhenPushed = true
        case 4:
            destinationVC = AboutUsVC()
            destinationVC?.hidesBottomBarWhenPushed = true
        case 5:
            destinationVC = TermsOfUseVC()
            destinationVC?.hidesBottomBarWhenPushed = true
        default:
            break
        }
        guard let destinationVC = destinationVC else { return }
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension SettingsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.settingsParameters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCVC.identifier, for: indexPath) as? SettingsCVC else { return UICollectionViewCell() }
        cell.configure(model: viewModel.settingsParameters[indexPath.item])
        return cell
    }
}

extension SettingsVC: ReturnToSettings {
    func returned(message: String) {
        self.showAlert(title: "Successfuly", message: message)
    }
}
