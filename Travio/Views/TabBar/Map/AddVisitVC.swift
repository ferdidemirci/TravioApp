//
//  AddVisitVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import Alamofire
import CoreLocation

class AddVisitVC: UIViewController {
    
    var viewModel = AddVisitVM()
    weak var delegate: ReturnToMap?
    
    var place = ""
    var latitude = 0.0
    var longitude = 0.0
    var urls: [String] = []
    
    private lazy var regtengleTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var placeNameView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Place Name"
        view.placeHolderText = "Please write a place name"
        return view
    }()
    
    private lazy var descriptionView: CustomTextViewView = {
        let view = CustomTextViewView()
        view.labelText = "Visit Description"
        
        return view
    }()
    
    private lazy var countryAndCityView: CustomTextFieldView = {
        let view = CustomTextFieldView()
        view.labelText = "Country, City"
        view.placeHolderText = "Please write a country and city name"
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 18
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AddVisitPhotoCVC.self, forCellWithReuseIdentifier: AddVisitPhotoCVC().identifier)
        return collectionView
    }()
    
    private lazy var addPlaceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Place", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: AppFont.semiBold.rawValue, size: 16)
        button.backgroundColor = AppColor.primaryColor.colorValue()
        button.addTarget(self, action: #selector(didTapAddPlace), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addPlaceButton.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
    }
    
    @objc private func didTapAddPlace() {
        viewModel.uploadImage { 
            if let place = self.placeNameView.textField.text,
               let description = self.descriptionView.textView.text,
               let countryAndCity = self.countryAndCityView.textField.text,
               let coverImage = self.viewModel.urls.first {
                let params: Parameters = ["place": countryAndCity,
                                          "title": place,
                                          "description": description,
                                          "cover_image_url": coverImage,
                                          "latitude": self.latitude,
                                          "longitude": self.longitude]
                
                self.viewModel.createPlace(parameters: params) {
                    self.delegate?.returned()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func configure(place: String) {
        countryAndCityView.textField.text = place
    }
    
    private func setupViews(){
        view.backgroundColor = AppColor.backgroundColor.colorValue()
        
        view.addSubviews(regtengleTop, placeNameView, descriptionView, countryAndCityView, collectionView, addPlaceButton)
        setupLayout()
    }
    
    private func setupLayout(){
        regtengleTop.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(8)
        }
        
        placeNameView.snp.makeConstraints { make in
            make.top.equalTo(regtengleTop.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(placeNameView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(224)
        }
        
        countryAndCityView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(countryAndCityView.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(215)
        }
        
        addPlaceButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
        }
        
    }
    
}

extension AddVisitVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width - 60, height: 215)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddVisitPhotoCVC().identifier, for: indexPath) as? AddVisitPhotoCVC else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        cell.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
        cell.addShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension AddVisitVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func stackViewTapped(row: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
               if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
                  let cell = collectionView.cellForItem(at: selectedIndexPath) as? AddVisitPhotoCVC {
                   cell.stackView.isHidden = true
                   cell.backgroundImageView.image = image
                   if let imageData = image.jpegData(compressionQuality: 0.5) {
                       viewModel.imagesData.append(imageData)
                   }
               }
           }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
