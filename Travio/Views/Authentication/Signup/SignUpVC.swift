//
//  SignUpVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class SignUpVC: UIViewController {
    
    var viewModel = SignUpVM()
    weak var delegate: ReturnToLogin?
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backBarButtonIcon"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 36)
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.addSubviews(usernameTextFieldView, emailTextFieldView, passwordTextFieldView, confirmPasswordTextFieldView, signUpButton)
        return view
    }()
    
    private lazy var usernameTextFieldView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Username"
        view.placeHolderText = "Enter your username"
        return view
    }()
    
    private lazy var emailTextFieldView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Email"
        view.placeHolderText = "Enter your email"
        return view
    }()
    
    private lazy var passwordTextFieldView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Password"
        view.placeHolderText = "Enter your password"
        view.secureTextEntry = true
        return view
    }()
    
    private lazy var confirmPasswordTextFieldView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Confirm Password"
        view.placeHolderText = "Enter your confirm password"
        view.secureTextEntry = true
        return view
    }()
    
    private lazy var signUpButton: CustomButton = {
        let button = CustomButton()
        button.title = "Sign Up"
        button.backgroundColor = AppColor.isEnabledColor.colorValue()
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextFieldView.textField.delegate = self
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self
        confirmPasswordTextFieldView.textField.delegate = self
        
        setupViews()
    }
    
    @objc private func didTapSignUpButton() {
        signUpButton.isEnabled = false
        guard let username = usernameTextFieldView.textField.text,
              let email = emailTextFieldView.textField.text,
              let password = passwordTextFieldView.textField.text,
              let confirmPassword = confirmPasswordTextFieldView.textField.text,
              isValidEmail(email: email),
              password == confirmPassword,
              (8..<15).contains(password.count) else {
            signUpButton.isEnabled = true
            showAlert(title: "Invalid Information", message: "Please make sure you fill out the information correctly and completely.")
            return
        }

        self.signUpButton.isEnabled = true
        let newUser = User(full_name: username, email: email, password: password)
        viewModel.postData(newUser) { [weak self] status in
            guard let self = self else { return }
            if status {
                self.signUpButton.isEnabled = true
                self.navigationController?.popToRootViewController(animated: true)
                self.delegate?.returned(message: "The registration process was completed successfully.")
            }  else {
                self.showAlert(title: "SignUp Failed!", message: "An unexpected error occurred during the registration process. Please try again.")
            }
        }
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = AppColor.primaryColor.colorValue()
        navigationController?.isNavigationBarHidden = true
        navigationItem.hidesBackButton = true
        view.addSubviews(backButton, titleLabel, mainView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.safeAreaLayoutGuide.snp.bottom).offset(52)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        usernameTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(72)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(usernameTextFieldView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        
        confirmPasswordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !usernameTextFieldView.textField.text!.isEmpty
            && !emailTextFieldView.textField.text!.isEmpty
            && passwordTextFieldView.textField.text!.count >= 8
            && passwordTextFieldView.textField.text!.count <= 15
            && passwordTextFieldView.textField.text == confirmPasswordTextFieldView.textField.text {
            
            signUpButton.backgroundColor = AppColor.primaryColor.colorValue()
            signUpButton.isEnabled = true
            
        } else {
            signUpButton.backgroundColor = AppColor.isEnabledColor.colorValue()
            signUpButton.isEnabled = false
        }
    }
}
