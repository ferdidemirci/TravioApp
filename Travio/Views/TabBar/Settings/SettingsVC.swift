//
//  SettingsVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 31.08.2023.
//

import UIKit
import SnapKit

class SettingsVC: UIViewController {
    
    let viewModel = SettingsVM()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        return view
    }()
    
    private lazy var imageViewProfile: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bruce")
        iv.backgroundColor = .clear
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 60
        return iv
    }()
    
    private lazy var lblName: UILabel = {
        let label = UILabel()
        label.text = "Bruce Wills"
        label.textColor = AppColor.backgroundDark.colorValue()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 16)
        return label
    }()

    private lazy var btnEditProfile: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 12)
        button.setTitleColor(AppColor.secondaryColor.colorValue(), for: .normal)
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
    }
    
    @objc private func didTapEditProfileButton() {
        let vc = EditProfileVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(titleLabel,
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
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(54)
            make.leading.trailing.bottom.equalToSuperview()
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
        switch indexPath.item {
        case 0:
            let securitySettingsVC = SecuritySettingsVC()
            securitySettingsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(securitySettingsVC, animated: true)
        default:
            break
        }
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
