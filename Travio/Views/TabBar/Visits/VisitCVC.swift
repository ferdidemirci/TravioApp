//
//  VisitCVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SDWebImage
import SnapKit

class VisitCVC: UICollectionViewCell {
    
    var identifier = "VisitCVC"
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var gradientImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "blackGradient")
        return image
    }()
    
    private lazy var locationImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "location")
        image.tintColor = .white
        return image
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: AppFont.light.rawValue, size: 16)
        return label
    }()
    
    override func layoutSubviews() {
        self.roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubviews(backgroundImageView, gradientImage, locationImageView, locationLabel)
        setupLayouts()
    }
    
    func setupLayouts() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientImage.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundImageView.snp.bottom)
            make.leading.equalTo(backgroundImageView)
            make.trailing.equalTo(backgroundImageView)
            make.height.equalTo(120)
        }
        locationImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(8)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalTo(locationImageView.snp.trailing).offset(6)
        }
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = contentView.bounds

        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public func congigure(model: Visit) {
        locationLabel.text = model.place.place
        if let imageUrl = URL(string: model.place.cover_image_url) {
            backgroundImageView.sd_setImage(with: imageUrl)
        } else {
            backgroundImageView.image = UIImage(systemName: "photo")
        }
    }
    
}