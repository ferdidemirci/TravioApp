//
//  VisitDetailsVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit
import MapKit

protocol ReturnToDismiss: AnyObject {
    func returned(message: String)
}

class CustomDetailsVC: UIViewController, MKMapViewDelegate {
    
    var visitId: String?
    var placeId: String?
    var placeDetails: Place?
    var isVisited = true
    var delegate: ReturnToDismiss?
    
    var viewModel = CustomDetailsVM()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(CustomDetailsSliderCVC.self, forCellWithReuseIdentifier: CustomDetailsSliderCVC().identifier)
        return collectionView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.backgroundStyle = .prominent
        pageControl.allowsContinuousInteraction = false
        pageControl.layer.cornerRadius = 12
        pageControl.pageIndicatorTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = AppColor.backgroundLight.colorValue()
        scrollView.addSubview(scrollContentView)
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        view.addSubviews(titleLabel, dateLabel, createdNameLabel, mapView, descriptionLabel)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 30)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.regular.rawValue, size: 14)
        return label
    }()
    
    private lazy var createdNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.regular.rawValue, size: 10)
        label.textColor = .systemGray
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var visitedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(UIColor.white, for: .normal)
        button.tintColor = .white
        button.setImage(UIImage(named: "bookmark.fill"), for: .normal)
        button.backgroundColor = AppColor.primaryColor.colorValue()
        button.addTarget(self, action: #selector(didTapVisitedButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppFont.regular.rawValue, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupApi()
        setupViews()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: scrollContentView.frame.height)
    }
    
    override func viewDidLayoutSubviews() {
        visitedButton.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapVisitedButton() {
        if let visitId {
            viewModel.deleteVisit(visitId: visitId) { message in
                self.navigationController?.popToRootViewController(animated: true)
                self.delegate?.returned(message: message)
            }
        } else {
            if let placeId {
                if isVisited {
                    viewModel.deleteVisit(visitId: placeId) { message in
                        self.showAlert(title: "Delete!", message: message)
                        self.visitedButton.setImage(UIImage(named: "bookmark"), for: .normal)
                        self.isVisited = false
                    }
                } else {
                    viewModel.createVisit(placeId: placeId) { Response in
                        self.showAlert(title: "Visit Insert!", message: "Place added successfully.")
                        self.visitedButton.setImage(UIImage(named: "bookmark.fill"), for: .normal)
                        self.isVisited = true
                    }
                }
            }
        }
    }
    
    @objc func pageControlValueChanged() {
        let currentPage = pageControl.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotation"
        var annotationView: MKAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            
            annotationView.image = UIImage(named: "mapLocation")
        }
        
        return annotationView
    }
    
    private func configure() {
        if let placeDetails {
            configureVisited()
            titleLabel.text = placeDetails.title
            dateLabel.text = formatISO8601Date(placeDetails.created_at)
            createdNameLabel.text = "added by @\(placeDetails.creator)"
            descriptionLabel.text = placeDetails.description
            
            let coordinate = CLLocationCoordinate2D(latitude: placeDetails.latitude, longitude: placeDetails.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = placeDetails.place
            mapView.addAnnotation(annotation)

            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func configureVisited() {
        if isVisited {
            visitedButton.setImage(UIImage(named: "bookmark.fill"), for: .normal)
        } else {
            
            visitedButton.setImage(UIImage(named: "bookmark"), for: .normal)
        }
    }
    
    private func setupApi() {
        if let placeDetails {
            viewModel.getVisitByPlaceId(placeId: placeDetails.id) { status in
                if status {
                    self.isVisited = true
                } else {
                    self.isVisited = false
                }
                self.configure()
            }
            
            viewModel.getGallery(placeId: placeDetails.id) {
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.galleries.count
            }
        }
    }
    
    private func setupViews(){
        mapView.delegate = self
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        view.addSubviews(collectionView, pageControl, backButton, visitedButton, scrollView)
        setupLayout()
    }
    
    private func setupLayout(){
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(40)
        }
        
        visitedButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
        }

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        scrollContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(24)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(26)
        }
        
        createdNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(-4)
            make.leading.equalToSuperview().offset(26)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(createdNameLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(227)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        scrollContentView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.bottom).offset(70)
        }
    }
}

extension CustomDetailsVC: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.frame.width), height: 250)
        return size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
    }
    
}

extension CustomDetailsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCellCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomDetailsSliderCVC().identifier, for: indexPath) as? CustomDetailsSliderCVC else { return UICollectionViewCell() }
        cell.configure(model: viewModel.getImage(index: indexPath.row))
        return cell
    }
}
