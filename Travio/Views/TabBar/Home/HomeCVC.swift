//
//  HomeCVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import UIKit
import SnapKit
import Kingfisher

class HomeCVC: UICollectionViewCell {
    
    static let identifier = "HomeCVC"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addCornerRadius(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
        view.addSubviews(backgroundImageView, gradientImage, titleLabel, locationImageView, locationLabel, activityIndicator)
        return view
    }()
    
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
        image.image = UIImage(named: "locationLight")
        image.tintColor = .white
        return image
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "İstanbul"
        label.font = UIFont(name: AppFont.light.rawValue, size: 14)
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
    
    override func layoutSubviews() {
        self.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
        self.addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            backgroundImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        
        self.addSubviews(backgroundImageView, gradientImage, titleLabel, stackView, activityIndicator)
        setupLayouts()
    }
    
    func setupLayouts() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        gradientImage.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func configure(model place: Place) {
        locationLabel.text = place.place
        titleLabel.text = place.title
        
        guard let urlStr = URL(string: place.cover_image_url) else {
            backgroundImageView.image = UIImage(named: "image.fill")
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
                    self.backgroundImageView.image = UIImage(named: "image.fill")
                }
            }
        )
    }
}

