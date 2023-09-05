//
//  HomeDetailVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 4.09.2023.
//

import Foundation

class HomeDetailVM {
    
    var placeArray: [MapPlace] = []
        
    func fetchPlaces(request: Router, completion: @escaping () -> Void) {
         NetworkHelper.shared.routerRequest(request: request) { (result: Result<MapPlaceResponse, Error>) in
             switch result {
             case .success(let data):
                 self.placeArray = data.data.places
                 completion()
             case .failure(let error):
                 print("Hata: \(error)")
             }
         }
     }
    
    func popularPlaces(completion: @escaping () -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.popularPlaces(limit: nil)) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let data):
                self.placeArray = data.data.places
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func lastPlaces(completion: @escaping () -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.lastPlaces(limit: nil)) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let data):
                self.placeArray = data.data.places
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func userPlaces(completion: @escaping () -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.lastPlaces(limit: nil)) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let data):
                self.placeArray = data.data.places
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sortingFromAtoZ() {
        placeArray = placeArray.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    func sortingFromZtoA() {
        placeArray = placeArray.sorted { $0.title > $1.title }
    }
}
