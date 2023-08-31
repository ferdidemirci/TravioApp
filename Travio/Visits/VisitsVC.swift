//
//  VisitsVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit

class VisitsVC: UIViewController {
    let viewModel = VisitsVM()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Visits"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 36)
        return label
    }()
    
    
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundColor.colorValue()
        view.addSubviews(collectionView, activityIndicator)
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColor.primaryColor.colorValue()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 29, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(VisitCVC.self, forCellWithReuseIdentifier: VisitCVC().identifier)
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupViews()
        
        viewModel.getVisits {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }

    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: .topLeft, radius: 80)
    }
    
    private func setupViews(){
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = AppColor.primaryColor.colorValue()
        view.addSubviews(titleLabel, mainView)
        setupLayout()
    }
    
    private func setupLayout(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(0)
        }
    }

}

extension VisitsVC: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 250)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: (collectionView.frame.width), height: 16)
        return size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.size.width
//        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
//        self.pageControl.page = page
//        skipShow(page != 3)
    }
    
}

extension VisitsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.visits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitCVC().identifier, for: indexPath) as? VisitCVC else { return UICollectionViewCell() }
        let data = viewModel.visits[indexPath.row]
        cell.congigure(model: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.visits[indexPath.row].place.id
        let data = viewModel.visits[indexPath.row].place
        let vc = CustomDetailsVC()
        vc.placeDetails = MapPlace(id: data.id,
                                   creator: data.creator,
                                   place: data.place,
                                   title: data.title,
                                   description: data.description,
                                   cover_image_url: data.cover_image_url,
                                   latitude: data.latitude,
                                   longitude: data.longitude,
                                   created_at: data.created_at,
                                   updated_at: data.updated_at)
        vc.placeId = id
        vc.visitedButtonStatus = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

