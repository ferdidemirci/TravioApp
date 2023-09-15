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
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        view.addSubviews(collectionView, activityIndicator)
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColor.primaryColor.colorValue()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 29, left: 24, bottom: 0, right: 24)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(VisitCVC.self, forCellWithReuseIdentifier: VisitCVC.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupData()
        NotificationCenterManager.shared.addObserver(observer: self, selector: #selector(VisitUpdateNotification))
    }

    @objc private func VisitUpdateNotification() {
        setupData()
    }
    
    private func setupData() {
        viewModel.getVisits { status in
            if status {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                self.showAlert(title: "Error!", message: "Fetching data from API failed. Please try again.")
            }
        }
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
            make.edges.equalToSuperview()
        }
    }
}

extension VisitsVC: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width - 48, height: 220)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: (collectionView.frame.width), height: 16)
        return size
    }
    
}

extension VisitsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.visits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitCVC.identifier, for: indexPath) as? VisitCVC else { return UICollectionViewCell() }
        let visit = viewModel.visits[indexPath.row].place
        cell.configure(model: visit)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let visit = viewModel.visits[indexPath.row]
        let vc = CustomDetailsVC()
        vc.setupVisitDeteail(with: visit, isVisited: true, delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VisitsVC: ReturnToDismiss {
    func returned(message: String) {
        self.showAlert(title: "Deletion process", message: message)
        setupData()
    }
    
    
}
