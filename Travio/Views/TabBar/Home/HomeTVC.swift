//
//  HomeTVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import UIKit
import SnapKit

enum Sections: Int {
    case popularPlaces = 0
    case lastPlaces = 1
    case userPlaces = 2
}

class HomeTVC: UITableViewCell {
    
    static let identifier = "HomeTVC"
    var viewModel = HomeTVCVM()
    weak var delegate: HomeCellDelegate?
    
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
        setupApi()
    }
    
    private func setupApi() {
        viewModel.popularPlaces {
            self.collectionView.reloadData()
        }
        viewModel.lastPlaces {
            self.collectionView.reloadData()
        }
        viewModel.userPlaces {
            self.collectionView.reloadData()
        }
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
            selectedPlaces = viewModel.popularPlaces[indexPath.row]
        case Sections.lastPlaces.rawValue:
            selectedPlaces = viewModel.lastPlaces[indexPath.row]
        case Sections.userPlaces.rawValue:
            selectedPlaces = viewModel.userPlaces[indexPath.row]
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
        return viewModel.popularPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVC.identifier, for: indexPath) as? HomeCVC else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case Sections.popularPlaces.rawValue:
            let place = viewModel.popularPlaces[indexPath.row]
            cell.congigure(model: place)
        case Sections.lastPlaces.rawValue:
            let place = viewModel.lastPlaces[indexPath.row]
            cell.congigure(model: place)
        case Sections.userPlaces.rawValue:
            let place = viewModel.lastPlaces[indexPath.row]
            cell.congigure(model: place)
        default:
            break
        }
        
        return cell
    }
}
