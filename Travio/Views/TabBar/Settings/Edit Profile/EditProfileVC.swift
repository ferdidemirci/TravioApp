//
//  EditProfileVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 4.09.2023.
//

import UIKit
import Alamofire
import SnapKit

class EditProfileVC: UIViewController {
    
    let viewModel = EditProfileVM()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile"
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
    
    private lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bruce")
        iv.backgroundColor = .red
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 60
        return iv
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Photo", for: .normal)
        button.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 12)
        button.setTitleColor(AppColor.primaryColor.colorValue(), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(changePhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var lblName: UILabel = {
        let label = UILabel()
        label.text = "Bruce Wills"
        label.textColor = AppColor.secondaryColor.colorValue()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 24)
        return label
    }()
    
    private lazy var birthView: CustomEditView = {
        let view = CustomEditView()
        view.backgroundColor = .white
        view.iconImage = "sign"
        return view
    }()
    
    private lazy var roleView: CustomEditView = {
        let view = CustomEditView()
        view.backgroundColor = .white
        view.iconImage = "role"
        return view
    }()
    
    private lazy var nameView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.backgroundColor = .white
        view.labelText = "Full Name"
        view.placeHolderText = "bilge_adam"
        return view
    }()
    
    private lazy var emailView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.backgroundColor = .white
        view.labelText = "Email"
        view.placeHolderText = "bilge_adam"
        return view
    }()
    
    private lazy var saveButton: CustomButton = {
        let button = CustomButton()
        button.title = "Save"
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configure()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changePhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        viewModel.uploadImage {
            guard let name = self.nameView.textField.text,
                  let email = self.emailView.textField.text,
                  let imageURL = self.viewModel.url?.first else { return }
            let params: Parameters = ["full_name": name,
                                      "email": email,
                                      "pp_url": imageURL]
            self.viewModel.editProfile(params: params)
        }
    }
    
    private func configure() {
        viewModel.getUserInfos { user in
            guard let name = user.full_name,
                  let createdDate = user.created_at,
                  let role = user.role else { return }
            self.lblName.text = name
            self.birthView.labelText = formatISO8601Date(createdDate) ?? "Unknown"
            self.roleView.labelText = role
        }
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(backButton,
                              titleLabel,
                              mainView)
        mainView.addSubviews(profileImage,
                             changePhotoButton,
                             lblName,
                             birthView,
                             roleView, nameView, emailView, saveButton)
        setupLayouts()
    }
    
    private func setupLayouts() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(22)
            make.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(23)
            make.leading.equalTo(backButton.snp.trailing).offset(24)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(54)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        changePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(86)
        }
        
        lblName.snp.makeConstraints { make in
            make.top.equalTo(changePhotoButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        birthView.snp.makeConstraints { make in
            make.top.equalTo(lblName.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(52)
            make.width.equalTo(163)
        }
        
        roleView.snp.makeConstraints { make in
            make.top.equalTo(lblName.snp.bottom).offset(20)
            make.leading.equalTo(birthView.snp.trailing).offset(16)
            make.height.equalTo(52)
            make.width.equalTo(163)
        }
        
        nameView.snp.makeConstraints { make in
            make.top.equalTo(birthView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        
        emailView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(16)
            make.leading.equalTo(nameView.snp.leading)
            make.trailing.equalTo(nameView.snp.trailing)
            make.height.equalTo(74)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(101)
            make.leading.equalTo(emailView.snp.leading)
            make.trailing.equalTo(emailView.snp.trailing)
            make.height.equalTo(54)
        }
        
    }
    
}

extension EditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                viewModel.imageData.append(imageData)
            }
        }
        picker.dismiss(animated: true)
    }
    
}

