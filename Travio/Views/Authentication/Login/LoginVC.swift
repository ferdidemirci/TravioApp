//
//  LoginVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit

class LoginVC: UIViewController {

    var loginViewModel = LoginVM()
    
    private lazy var loginScreenImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "travioTextLogo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        view.addSubviews(titleLabel, emailTextFieldView, passwordTextFieldView, loginButton, bottomStackView)
        return view
    }()
    
    private lazy var emailTextFieldView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Email"
        view.textField.text = "ferdidemirci@gmail.com"
        return view
    }()
    
    private lazy var passwordTextFieldView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Password"
        view.textField.text = "Ferdi.123"
        view.secureTextEntry = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Travio"
        label.font = UIFont(name: AppFont.medium.rawValue, size: 24)
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = AppColor.primaryColor.colorValue()
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(signUpButton)
        return stackView
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have any account?"
        label.font = UIFont(name: AppFont.regular.rawValue, size: 16)
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: AppFont.medium.rawValue, size: 16)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapSignButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = AppColor.primaryColor.colorValue()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: .topLeft, radius: 80)
        loginButton.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 12)
    }
    
    @objc private func didTapLoginButton() {
        if let email = emailTextFieldView.textField.text,
            let password = passwordTextFieldView.textField.text {
            loginViewModel.postLogin(email: email, password: password) {
                let vc = MainTabBarC()
                let targetVC = VisitsVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc private func didTapSignButton() {
        let vc = SignUpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.addSubviews(loginScreenImageView, mainView)
        setupLayouts()
    }
    
    private func setupLayouts() {

        
        loginScreenImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(loginScreenImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.centerX.equalToSuperview()
        }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(41)
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
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(21)
            make.centerX.equalToSuperview()
        }
        
    }
}
