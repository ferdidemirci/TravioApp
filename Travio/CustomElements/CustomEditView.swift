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
        let iv = UIImageView()
        iv.image = UIImage(named: iconImage)
        iv.backgroundColor = .clear
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.medium.rawValue, size: 12)
        label.text = labelText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
      
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.roundCorners(corners: [.allCorners], radius: 16)
    }
    
    private func setupViews() {
        self.backgroundColor = .white
        self.addSubviews(iconImageView,
                         titleLabel)
        self.addShadow()
        
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
    
}
