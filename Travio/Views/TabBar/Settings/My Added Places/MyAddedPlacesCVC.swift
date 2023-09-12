//
//  MyAddedPlacesCVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 11.09.2023.
//

import UIKit
import SnapKit

class MyAddedPlacesCVC: UICollectionViewCell {
    
    static let identifier = "MyAddedPlacesCVC"
    
    private lazy var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 24)
        label.numberOfLines = 0
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.tintColor = .red
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.addCornerRadius(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
    }
    
    public func configure(model place: Place) {
        locationLabel.text = place.place
        titleLabel.text = place.title
        
        guard let urlStr = URL(string: place.cover_image_url) else {
            placeImageView.image = UIImage(systemName: "photo")
            return
        }
        
        activityIndicator.startAnimating()
        
        placeImageView.kf.setImage(
            with: urlStr,
            completionHandler: { [weak activityIndicator] result in
                activityIndicator?.stopAnimating()
                activityIndicator?.removeFromSuperview()
                switch result {
                case .success:
                    break
                case .failure:
                    self.placeImageView.image = UIImage(systemName: "photo")
                }
            }
        )
        
    }
    
    func setupViews() {
        contentView.addSubviews(placeImageView, titleLabel, stackView, activityIndicator)
        setupLayouts()
    }
    
    func setupLayouts() {
        
        placeImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(placeImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel).offset(4)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(12)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
    }
    
}
