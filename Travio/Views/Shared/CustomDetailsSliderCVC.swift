//
//  VisitDetailSliderCell.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        contentView.addSubviews(sliderImage, gradientImage, activityIndicator)
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
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func configure(model image: Image) {
        
        guard let url = URL(string: image.image_url) else {
            sliderImage.image = UIImage(named: "image.fill")
            return
        }
        
        loadImageWithActivityIndicator(from: url, indicator: activityIndicator, into: sliderImage)
    }

}

