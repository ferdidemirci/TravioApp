//
//  HomeDetailVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import UIKit

class HomeDetailVC: UIViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backBarButtonIcon"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Places"
        label.font = UIFont(name: AppFont.bold.rawValue, size: 32)
        label.textColor = .white
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundColor.colorValue()
        view.addSubviews(collectionView, fromSmallButton, fromBigButton)
        return view
    }()
    
    private lazy var fromSmallButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fromSmall"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var fromBigButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fromBig"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeDetailCVC.self, forCellWithReuseIdentifier: HomeDetailCVC.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: .topLeft, radius: 80)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupViews(){
        view.backgroundColor = AppColor.primaryColor.colorValue()
        
        view.addSubviews(backButton, titleLabel, mainView)
        setupLayout()
    }
    
    private func setupLayout(){
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(19)
            make.centerX.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(58)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        fromBigButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(25)
            make.height.equalTo(22)
        }
        
        fromSmallButton.snp.makeConstraints { make in
            make.top.equalTo(fromBigButton)
            make.trailing.equalTo(fromBigButton.snp.leading).offset(-24)
            make.width.equalTo(25)
            make.height.equalTo(22)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
}

extension HomeDetailVC: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 89)
        return size
    }
}

extension HomeDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailCVC.identifier, for: indexPath) as? HomeDetailCVC else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        return cell
    }
}
