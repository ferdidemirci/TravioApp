//
//  PasswordTVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 1.09.2023.
//

import UIKit
import SnapKit

class PasswordTVC: UITableViewCell {
    
    static let identifier = "PasswordTVC"
    
    private lazy var textField: CustomTextFieldView = {
        let view = CustomTextFieldView()
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
        textField.titleLabel.text = title
    }
    
    private func setupViews() {
        contentView.addSubview(textField)
        setupLayouts()
    }
    
    private func setupLayouts() {
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
