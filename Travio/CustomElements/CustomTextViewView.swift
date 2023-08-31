//
//  CustomTextViewView.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//
import UIKit
import SnapKit

class CustomTextViewView: UIView {
    
    var labelText: String = "" {
        didSet {
            titleLabel.text = labelText
        }
    }
    
    var placeHolderText: String = "" {
        didSet {
            
        }
    }
    
    var secureTextEntry: Bool = false {
        didSet {
            textView.isSecureTextEntry = true
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.medium.rawValue, size: 14)
        label.text = labelText
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: AppFont.light.rawValue, size: 14)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.textColor = .lightGray
        textView.delegate = self
        textView.text = "Please enter a description"
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    
    private func setupViews() {
        backgroundColor = .white
        
        self.addShadow()
        addSubviews(titleLabel, textView)
        
        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(162)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func addShadow() {
//        layer.shadowColor = UIColor.gray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowOpacity = 0.1
//        layer.shadowRadius = 20
//        clipsToBounds = false
//        layer.cornerRadius = 16
//        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
//    }
}

extension CustomTextViewView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty && textView.text == "Please enter a description" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter a description"
            textView.textColor = UIColor.lightGray
        }
    }
}
