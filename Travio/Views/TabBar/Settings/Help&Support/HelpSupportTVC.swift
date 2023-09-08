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
    var isExpanded = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "How can I save a visit?"
        label.font = UIFont(name: AppFont.medium.rawValue, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "down"), for: .normal)
        button.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
//        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
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
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        contentView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
    }
    
    @objc private func downButtonTapped() {
        isExpanded.toggle()
        expandButton.isSelected = isExpanded
        print("tapped")
        if let tableView = superview as? UITableView {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
    }
    
    public func configure(with model: FAQItem) {
        titleLabel.text = model.question
        descriptionLabel.text = model.answer
    }
    
    private func setupViews() {
        self.contentView.addSubviews(titleLabel, expandButton, descriptionLabel)
        self.contentView.backgroundColor = .white
        self.backgroundColor = .clear
        setupLayouts()
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(expandButton.snp.leading).offset(12)
        }
        
        expandButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(25)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

}
