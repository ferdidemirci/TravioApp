//
//  CustomButton.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 6.09.2023.
//

import UIKit
import SnapKit

class CustomButton: UIButton {
    
    var title: String = "" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = AppColor.primaryColor.colorValue()
        self.titleLabel?.font = UIFont(name: AppFont.semiBold.rawValue, size: 16)
        self.addCornerRadius(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 12)
    }
    
    private func setupLayouts() {
        self.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
    }
}
