//
//  CustomTextViewView.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit

class CustomTextFieldView: UIView {
    
    var labelText: String = "" {
        didSet {
            titleLabel.text = labelText
        }
    }
    
    var placeHolderText: String = "" {
        didSet {
            textField.placeholder = placeHolderText
        }
    }
    
    var secureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = true
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.medium.rawValue, size: 14)
        label.text = labelText
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "Enter your email"
        textField.font = UIFont(name: AppFont.light.rawValue, size: 14)
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
      
        setupViews()
    }
    
   
    
    private func setupViews() {
        backgroundColor = .white
        self.addShadow()
        addSubviews(titleLabel, textField)
        
        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
