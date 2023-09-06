//
//  HomeTVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import UIKit
import SnapKit



class HomeTVC: UITableViewCell {
    
    static let identifier = "HomeTVC"
    weak var delegate: HomeCellDelegate?
    var placeArray = [MapPlace]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCVC.self, forCellWithReuseIdentifier: HomeCVC.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = AppColor.backgroundLight.colorValue()
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupViews()
    }
    
    func setupViews() {
        self.addSubview(collectionView)
        setupLayouts()
    }
    
    func setupLayouts() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func didTapDidSelect(indexPath: IndexPath) {
        var selectedPlaces: MapPlace?

        switch indexPath.section {
        case Sections.popularPlaces.rawValue:
            selectedPlaces = placeArray[indexPath.row]
        case Sections.lastPlaces.rawValue:
            selectedPlaces = placeArray[indexPath.row]
        case Sections.userPlaces.rawValue:
            selectedPlaces = placeArray[indexPath.row]
        default:
            break
        }

        let vc = CustomDetailsVC()
        if let selectedPlaces {
            vc.placeId = selectedPlaces.id
            vc.placeDetails = selectedPlaces
            self.delegate?.cellDidTapButton(indexPath, vc)
        }
    }
    
    func configure(places: [MapPlace]) {
        self.placeArray = places
        self.collectionView.reloadData()
    }
}



extension HomeTVC: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width - 60, height: 180)
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapDidSelect(indexPath: indexPath)
    }
}

extension HomeTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVC.identifier, for: indexPath) as? HomeCVC else { return UICollectionViewCell() }
        let place = placeArray[indexPath.row]
        cell.congigure(model: place)
        return cell
    }
}
