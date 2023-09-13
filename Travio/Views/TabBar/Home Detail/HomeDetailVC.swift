//
//  HomeDetailVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import UIKit

class HomeDetailVC: UIViewController {
    
    var viewModel = HomeDetailVM()
    var viewTag: Int?
    var sectionTitle: String?
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
        label.text = "Popular Places"
        label.font = UIFont(name: AppFont.bold.rawValue, size: 32)
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
        collectionView.register(HomeDetailCVC.self, forCellWithReuseIdentifier: HomeDetailCVC.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupApi()
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapSortButton() {
        isToggle.toggle()
        if isToggle {
            sortButton.setImage(UIImage(named: "fromZ"), for: .normal)
            viewModel.sortingFromAtoZ()
        } else {
            sortButton.setImage(UIImage(named: "fromA"), for: .normal)
            viewModel.sortingFromZtoA()
        }
        collectionView.reloadData()
    }
    
    private func setupApi() {
        let request: Router
        var shouldReloadData = false
        
        switch viewTag {
        case 0:
            request = Router.popularPlaces(limit: nil)
            shouldReloadData = true
        case 1:
            request = Router.lastPlaces(limit: nil)
            shouldReloadData = true
        case 2:
            request = Router.lastPlaces(limit: nil)
            shouldReloadData = true
        default:
            return
        }
        
        viewModel.fetchPlaces(request: request) {
            if shouldReloadData {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupViews(){
        view.backgroundColor = AppColor.primaryColor.colorValue()
        titleLabel.text = sectionTitle
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

extension HomeDetailVC: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 89)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placeId = viewModel.placeArray[indexPath.row].id
        let placeDetails = viewModel.placeArray[indexPath.row]
        let vc = CustomDetailsVC()
        vc.placeId = placeId
        vc.placeDetails = placeDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.placeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailCVC.identifier, for: indexPath) as? HomeDetailCVC else { return UICollectionViewCell() }
        let place = viewModel.placeArray[indexPath.row]
        cell.configure(model: place)
        return cell
    }
}

extension HomeDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + 50  > 0 {
            sortButton.isHidden = true
        } else {
            sortButton.isHidden = false
        }
    }

}
