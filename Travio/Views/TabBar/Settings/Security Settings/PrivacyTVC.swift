//
//  PrivacyTVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 1.09.2023.
//

import UIKit
import SnapKit

class PrivacyTVC: UITableViewCell {
    
    static let identifier = "PrivacyTVC"
    
    lazy var privacyView: CustomPrivacyView = {
        let view = CustomPrivacyView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
    }
    
    func configure(title: String) {
        privacyView.labelText = title
    }
    
    private func setupViews() {
        contentView.addSubview(privacyView)
        setupLayouts()
        privacyView.switchOnOff.addTarget(self, action: #selector(permissionOnDeviceSettings(_ :)), for: .valueChanged)
    }
    
    private func setupLayouts() {
        privacyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    @objc func permissionOnDeviceSettings(_ sender: UISwitch) {
        
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        
    }
    
}
