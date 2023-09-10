//
//  VisitCVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 24)
        label.textColor = .white
        return label
    }()
    
    private lazy var locationImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "locationLight")
        image.tintColor = .white
        return image
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: AppFont.light.rawValue, size: 16)
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 16)
    }
    
    func setupViews() {
        self.contentView.addSubviews(backgroundImageView, activityIndicator, gradientImage, titleLabel, locationImageView, locationLabel)
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
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(locationImageView.snp.top)
            make.leading.equalToSuperview().offset(8)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(8)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalTo(locationImageView.snp.trailing).offset(6)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func configure(model visit: VisitPlace) {
        locationLabel.text = visit.place
        titleLabel.text = visit.title
        
        guard let urlStr = URL(string: visit.cover_image_url) else {
            backgroundImageView.image = UIImage(systemName: "photo")
            return
        }
        
        activityIndicator.startAnimating()
        backgroundImageView.kf.setImage(
            with: urlStr,
            completionHandler: { [weak activityIndicator] result in
                activityIndicator?.stopAnimating()
                activityIndicator?.removeFromSuperview()
                switch result {
                case .success:
                    break
                case .failure:
                    self.backgroundImageView.image = UIImage(systemName: "photo")
                }
            }
        )
    }
}
