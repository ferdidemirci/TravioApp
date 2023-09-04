//
//  HomeDetailCVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import UIKit

class HomeDetailCVC: UICollectionViewCell {
    
    static let identifier = "HomeDetailCVC"
    
    private lazy var placeImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "england")
        return image
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 24)
        label.text = "London"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.addArrangedSubview(locationImageView)
        stackView.addArrangedSubview(locationLabel)
        return stackView
    }()
    
    private lazy var locationImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "location")
        image.tintColor = .red
        return image
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "İstanbul"
        label.font = UIFont(name: AppFont.light.rawValue, size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 16)
//        self.addShadow()
    }
    
    func setupViews() {
        contentView.addSubviews(placeImageView, placeLabel, stackView)
        setupLayouts()
    }
    
    func setupLayouts() {
        
        placeImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(placeImageView.snp.trailing).offset(8)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom)
            make.leading.equalTo(placeLabel).offset(4)
        }
    }
    
    public func congigure(model: Image) {
        
    }
}
