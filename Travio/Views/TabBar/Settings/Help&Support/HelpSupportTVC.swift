//
//  HelpSupportTVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 7.09.2023.
//

import UIKit
import SnapKit

class HelpSupportTVC: UITableViewCell {
    
    static let identifier = "HelpSupportTVC"
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.medium.rawValue, size: 14)
        label.numberOfLines = 0
//        label.backgroundColor = .red
        return label
    }()
    
    private lazy var expandIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "down")
        return iv
    }()
    
     lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.light.rawValue, size: 10)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        contentView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
    }
    
    public func configure(with model: FAQItem) {
        questionLabel.text = model.question
        descriptionLabel.text = model.answer
    }
    
    private func setupViews() {
        self.contentView.addSubviews(questionLabel,
                                     expandIcon,
                                     descriptionLabel)
        self.contentView.backgroundColor = .white
        self.backgroundColor = .clear
        setupLayouts()
    }
    
    private func setupLayouts() {
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(expandIcon.snp.leading).offset(-12)
//            make.centerY.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-16)
//            make.height.equalTo(42)
        }
        
        expandIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalTo(questionLabel.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(25)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
            make.leading.equalTo(questionLabel.snp.leading)
            make.trailing.equalTo(questionLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

}
