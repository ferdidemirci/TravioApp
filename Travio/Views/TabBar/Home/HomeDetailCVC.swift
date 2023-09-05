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
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 24)
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
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "locationDark")
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
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
            make.trailing.equalToSuperview().offset(-8)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(4)
            make.leading.equalTo(placeLabel).offset(4)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(12)
        }
    }
    
    public func congigure(model: MapPlace) {
        placeLabel.text = model.title
        locationLabel.text = model.place
        
        if let url = URL(string: model.cover_image_url) {
            placeImageView.kf.setImage(with: url)
        }
        
    }
}
