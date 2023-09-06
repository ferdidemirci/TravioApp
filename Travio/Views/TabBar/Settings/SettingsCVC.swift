//
//  SettingsCVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 31.08.2023.
//

import UIKit
import SnapKit

class SettingsCVC: UICollectionViewCell {

    static let identifier = "SettingsCVC"
    
    
    // Shadow'u verdiğimiz view
    private lazy var customView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var imageViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondaryColor.colorValue()
        label.font = UIFont(name: AppFont.light.rawValue, size: 14)
        return label
    }()
    
    private lazy var imageViewForward: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "forward")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    override func layoutSubviews() {
        contentView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
        contentView.addShadow()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: SettingsModel) {
        self.imageViewIcon.image = UIImage(named: model.leftImage)
        self.lblTitle.text = model.text
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubviews(customView)
        customView.addSubviews(imageViewIcon,
                                lblTitle,
                                imageViewForward)

        
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        
        
        // Shadow normal yöntemle denenecek
        customView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(3)
            make.trailing.bottom.equalToSuperview().offset(-3)
        }

        imageViewIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.leading.equalTo(imageViewIcon.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        imageViewForward.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-19)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
        }
        
    }
    
}
