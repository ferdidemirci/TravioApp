//
//  SettingsVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 31.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

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
        view.backgroundColor = AppColor.backgroundColor.colorValue()
        return view
    }()
    
    private lazy var imageViewProfile: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 60
        return iv
    }()
    
    private lazy var lblName: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondaryColor.colorValue()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 16)
        return label
    }()

    private lazy var btnEditProfile: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 12)
        button.setTitleColor(AppColor.primaryColor.colorValue(), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SettingsCVC.self, forCellWithReuseIdentifier: SettingsCVC.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: [.topLeft], radius: 80)        
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.deleteAccessToken {
            
        }
    }
    
    @objc private func didTapEditProfileButton() {
        let vc = EditProfileVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configure() {
        viewModel.getUserInfos { user in
            guard let imageURL = user.pp_url,
                  let name = user.full_name else { return }
            self.imageViewProfile.kf.setImage(with: URL(string: imageURL))
            self.lblName.text = name
        }
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(titleLabel,
                              logoutButton,
                              mainView)
        self.mainView.addSubviews(imageViewProfile,
                                  lblName,
                                  btnEditProfile,
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        imageViewProfile.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        lblName.snp.makeConstraints { make in
            make.top.equalTo(imageViewProfile.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        btnEditProfile.snp.makeConstraints { make in
            make.top.equalTo(lblName.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(62)
            make.height.equalTo(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(btnEditProfile.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
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
            destinationVC = SecuritySettingsVC()
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
