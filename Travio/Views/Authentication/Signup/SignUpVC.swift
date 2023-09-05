//
//  SignUpVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit

class SignUpVC: UIViewController {
    
    var signUpViewModel = SignUpVM()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SignUp"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 36)
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        view.addSubview(usernameTextFieldView)
        view.addSubview(emailTextFieldView)
        view.addSubview(passwordTextFieldView)
        view.addSubview(confirmPasswordTextFieldView)
        view.addSubview(signUpButton)
        return view
    }()
    
    private lazy var usernameTextFieldView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Username"
        view.placeHolderText = "Enter your usernmae"
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
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = AppColor.isEnabledColor.colorValue()
        button.isEnabled = true
        button.addTarget(self, action: #selector(didTapSignButton), for: .touchUpInside)
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
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: .topLeft, radius: 80)
        signUpButton.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 12)

    }
    
    @objc private func didTapSignButton() {
        if let username = usernameTextFieldView.textField.text,
           let email = emailTextFieldView.textField.text,
           let password = passwordTextFieldView.textField.text,
           let confirmPassword = confirmPasswordTextFieldView.textField.text {
            
            if password == confirmPassword && password.count < 15 && password.count > 6 {
                
                let newUser = User(full_name: username, email: email, password: password)
                
                signUpViewModel.postData(newUser, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = AppColor.primaryColor.colorValue()
        navigationController?.isNavigationBarHidden = false
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 36)
                ]
        
        view.addSubviews(titleLabel, mainView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-22)
            make.centerX.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(54)
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
            make.height.equalTo(54)
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !usernameTextFieldView.textField.text!.isEmpty &&
            !emailTextFieldView.textField.text!.isEmpty
            && passwordTextFieldView.textField.text!.count >= 8 &&
            passwordTextFieldView.textField.text == confirmPasswordTextFieldView.textField.text {
            signUpButton.backgroundColor = AppColor.primaryColor.colorValue()
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = AppColor.isEnabledColor.colorValue()
            signUpButton.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextFieldView.textField {
            let newEmail = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let isValid = isValidEmail(email: newEmail)
                return true
            }
            return true
        }
}
