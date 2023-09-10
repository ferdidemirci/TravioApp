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
    
    private lazy var privacyView: CustomPrivacyView = {
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
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    func configure(title: String) {
        privacyView.labelText = title
    }
    
    private func setupViews() {
        contentView.addSubview(privacyView)
        self.backgroundColor = AppColor.backgroundLight.colorValue()
        setupLayouts()
    }
    
    private func setupLayouts() {
        privacyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
}
