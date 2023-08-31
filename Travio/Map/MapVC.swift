//
//  MapVC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import MapKit
import SnapKit

protocol ReturnToMap: AnyObject {
    func returned()
}

class MapVC: UIViewController, MKMapViewDelegate{
    
    var viewModel = MapVM()
    var place = ""
    
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 18
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MapCVC.self, forCellWithReuseIdentifier: MapCVC().identifier)
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setupViews(){
        setupData()
        
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        view.addSubviews(mapView, collectionView)
        setupLayout()
    }
    
    private func setupLayout(){
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-18)
            make.height.equalTo(178)
        }
    }
    
    func setupData() {
        viewModel.getData {
            self.collectionView.reloadData()
            for location in self.viewModel.mapPlaces {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            getAddressFromCoordinate(coordinate: coordinate) {
                let vc = AddVisitVC()
                vc.delegate = self
                vc.configure(place: self.place)
                vc.latitude = coordinate.latitude
                vc.longitude = coordinate.longitude
                self.present(vc, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let pinImage = UIImage(named: "mapLocation") {
            let size = CGSize(width: 32, height: 42)
            
            UIGraphicsBeginImageContext(size)
            pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
        }
        return annotationView
    }
    
    func getAddressFromCoordinate(coordinate: CLLocationCoordinate2D, complate: @escaping () -> Void){
        let geocoder = CLGeocoder()
           
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
           
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                if let street = placemark.thoroughfare,
                   let city = placemark.locality,
                    let country = placemark.country {
                    self.place = "\(city), \(country)"
                    complate()
                }
            }
        }
    }
}

extension MapVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width - 60, height: 178)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mapPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCVC().identifier, for: indexPath) as? MapCVC else { return UICollectionViewCell() }
        cell.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
        cell.congigure(model: viewModel.mapPlaces[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placeId = viewModel.mapPlaces[indexPath.row].id
        let placeDetail = viewModel.mapPlaces[indexPath.row]
        let vc = CustomDetailsVC()
        vc.placeId = placeId
        print("Place ID: \(placeId)")
        vc.placeDetails = placeDetail
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension MapVC: ReturnToMap {
    func returned() {
        print("Map returned")
        setupData()
    }
}
