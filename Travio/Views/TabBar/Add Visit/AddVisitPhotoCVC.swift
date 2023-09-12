//
//  AddVisitPhotoCVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit

class AddVisitPhotoCVC: UICollectionViewCell, UIPickerViewDelegate {
    
    static let identifier = "AddVisitPhotoCVC"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.addSubviews(backgroundImageView, stackView)
        view.backgroundColor = .white
        view.addCornerRadius(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.addArrangedSubview(addPhotoImageView)
        stackView.addArrangedSubview(addPhotoLabel)
        return stackView
        
    }()
    
    private lazy var addPhotoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "cameraIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo"
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.font = UIFont(name: AppFont.light.rawValue, size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
        self.addShadow()
    }

    func setupViews() {
        contentView.addSubviews(containerView)
        setupLayouts()
    }
    
    func setupLayouts() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addPhotoImageView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(35)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
