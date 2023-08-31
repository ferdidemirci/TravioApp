//
//  VisitDetailSliderCell.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SDWebImage
import SnapKit

class CustomDetailsSliderCVC: UICollectionViewCell {
    
    var identifier = "CustomDetailsSliderCVC"
    
    private lazy var sliderImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "istanbul")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var gradientImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "whiteGradient")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        contentView.addSubviews(sliderImage, gradientImage)
        setupLayouts()
    }
    
    func setupLayouts() {
        sliderImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientImage.snp.makeConstraints { make in
            make.bottom.equalTo(sliderImage.snp.bottom).offset(0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(110)
        }
    }
    
    public func congigure(model: Image) {
        if let imageUrl = URL(string: model.image_url) {
            sliderImage.sd_setImage(with: imageUrl)
        } else {
            sliderImage.image = UIImage(systemName: "photo")
        }
    }
}

