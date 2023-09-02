//
//  MapCVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import Kingfisher
import SnapKit

class MapCVC: UICollectionViewCell {
    
    var identifier = "MapCVC"
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var gradientImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "blackGradient")
        return image
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
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    override func layoutSubviews() {
        self.addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UIImagePickerController'dan seçilen resmi alma ve UIImageView'a koyma
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            backgroundImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        
        self.addSubviews(backgroundImage, gradientImage, stackView)
        setupLayouts()
    }
    
    func setupLayouts() {
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        gradientImage.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(22)
            make.bottom.equalToSuperview().offset(-14)
        }
    }
    
    public func congigure(model: MapPlace) {
        locationLabel.text = model.place
        
        if let url = URL(string: model.cover_image_url) {
            backgroundImage.kf.setImage(with: url)
        }
        
    }
}

