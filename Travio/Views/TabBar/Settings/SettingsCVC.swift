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
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.backgroundDark.colorValue()
        label.font = UIFont(name: AppFont.light.rawValue, size: 14)
        return label
    }()
    
    private lazy var forwardImageView: UIImageView = {
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
        self.addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: SettingsModel) {
        self.iconImageView.image = UIImage(named: model.leftImage)
        self.titleLabel.text = model.text
    }
    
    private func setupViews() {
        contentView.addSubviews(containerView)
        containerView.addSubviews(iconImageView,
                                titleLabel,
                                forwardImageView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        forwardImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(16)
        }
    }
}
