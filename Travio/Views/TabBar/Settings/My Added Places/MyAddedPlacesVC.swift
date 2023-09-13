//
//  MyAddedPlacesVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 11.09.2023.
//

import UIKit
import SnapKit

class MyAddedPlacesVC: UIViewController {
    
    let viewModel = MyAddedPlacesVM()
    var isToggle = false
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backBarButtonIcon"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Added Places"
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        label.textColor = .white
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        view.addSubviews(collectionView, sortButton)
        return view
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fromA"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        collectionView.register(MyAddedPlacesCVC.self, forCellWithReuseIdentifier: MyAddedPlacesCVC.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configure()
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapSortButton() {
        isToggle.toggle()
        if isToggle {
            sortButton.setImage(UIImage(named: "fromZ"), for: .normal)
            viewModel.sortFromAtoZ()
        } else {
            sortButton.setImage(UIImage(named: "fromA"), for: .normal)
            viewModel.sortFromZtoA()
        }
        collectionView.reloadData()
    }
    
    private func configure() {
        viewModel.getAllPlacesForUser { success in
            if success {
                self.collectionView.reloadData()
            } else {
                print(self.debugDescription)
            }
        }
    }
    
    private func setupViews(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = AppColor.primaryColor.colorValue()
        view.addSubviews(backButton, titleLabel, mainView)
        setupLayout()
    }
    
    private func setupLayout(){
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(22)
            make.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(19)
            make.leading.equalTo(backButton.snp.trailing).offset(24)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(58)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}

extension MyAddedPlacesVC: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 89)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placeId = viewModel.myAddedPlaces[indexPath.row].id
        let placeDetails = viewModel.myAddedPlaces[indexPath.row]
        let vc = CustomDetailsVC()
        vc.placeId = placeId
        vc.placeDetails = placeDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyAddedPlacesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.myAddedPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyAddedPlacesCVC.identifier, for: indexPath) as? MyAddedPlacesCVC else { return UICollectionViewCell() }
        let places = viewModel.myAddedPlaces[indexPath.row]
        cell.configure(model: places)
        return cell
    }
}

extension MyAddedPlacesVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + 50  > 0 {
            sortButton.isHidden = true
        } else {
            sortButton.isHidden = false
        }
    }

}
