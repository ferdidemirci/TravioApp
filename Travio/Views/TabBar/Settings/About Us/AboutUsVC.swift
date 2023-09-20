//
//  AboutUsVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 12.09.2023.
//

import UIKit
import SnapKit
import WebKit

class AboutUsVC: UIViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backBarButtonIcon"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "About Us"
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        label.textColor = .white
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = AppColor.backgroundLight.colorValue()
        webView.navigationDelegate = self
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        webView.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupViews(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = AppColor.primaryColor.colorValue()
        view.addSubviews(backButton,
                         titleLabel,
                         mainView)
        mainView.addSubviews(webView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(22)
            make.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(24)
            make.centerY.equalTo(backButton.snp.centerY)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(58)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

extension AboutUsVC: WKNavigationDelegate {
    override func loadView() {
        super.loadView()
        
        guard let url = URL(string: "https://api.iosclass.live/about") else { return }
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
    }
}
