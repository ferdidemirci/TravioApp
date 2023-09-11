//
//  CustomEditView.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 1.09.2023.
//

import UIKit
import SnapKit

class CustomEditView: UIView {
    
    var labelText: String = "" {
        didSet {
            titleLabel.text = labelText
        }
    }
    
    var iconImage: String = "" {
        didSet {
            iconImageView.image = UIImage(named: iconImage)
        }
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: iconImage)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.medium.rawValue, size: 12)
        label.text = labelText
        label.textColor = AppColor.backgroundDark.colorValue()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
      
        setupViews()
    }
    
    override func layoutSubviews() {
        self.addShadow()
    }
    
    private func setupViews() {
        self.addCornerRadius(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
        self.backgroundColor = .white
        self.addSubviews(iconImageView,
                         titleLabel)
        setupLayouts()
    }
    
    private func setupLayouts() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
