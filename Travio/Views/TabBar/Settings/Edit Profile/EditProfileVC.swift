//
//  EditProfileVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 4.09.2023.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class EditProfileVC: UIViewController {
    
    let viewModel = EditProfileVM()
    var user: Me?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 60
        return imageView
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.backgroundDark.colorValue()
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configure()
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
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
            self.viewModel.editProfile(params: params) { status, message in
                self.handleProfileEditResult(status, message)
            }
        }
    }
    
    private func handleProfileEditResult(_ status: Bool, _ message: String) {
            if status {
                self.dismiss(animated: true)
                self.showAlert(title: "Successfuly!", message: message)
            } else {
                self.showAlert(title: "Error!", message: message)
            }
        }
    
    private func configure() {
        if let user = user {
            guard let imageURL = user.pp_url,
                  let name = user.full_name,
                  let createdDate = user.created_at,
                  let role = user.role,
                  let url = URL(string: imageURL) else {
                self.profileImageView.image = UIImage(named: "person.fill")
                return
            }
            
            self.nameLabel.text = name
            self.birthView.labelText = formatISO8601Date(createdDate) ?? "Unknown"
            self.roleView.labelText = role
            
            loadImageWithActivityIndicator(from: url, indicator: activityIndicator, into: profileImageView, imageName: "person.fill")
        }
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(titleLabel,
                              closeButton,
                              mainView)
        mainView.addSubviews(profileImageView,
                             activityIndicator,
                             changePhotoButton,
                             nameLabel,
                             birthView,
                             roleView, nameView, emailView, saveButton)
        setupLayouts()
    }
    
    private func setupLayouts() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.width.equalTo(20)
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
        
        changePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(86)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(changePhotoButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        birthView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(52)
            make.width.equalTo(163)
        }
        
        roleView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
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
            profileImageView.image = image
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                viewModel.imageData.append(imageData)
            }
        }
        picker.dismiss(animated: true)
    }
}

