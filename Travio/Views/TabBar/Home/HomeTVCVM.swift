//
//  HomeVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import Foundation

class HomeTVCVM {
    let sectionTitles = ["Popular Places", "Last Places", "Visit Places"]
    var popularPlaces: [MapPlace] = []
    var lastPlaces: [MapPlace] = []
    var userPlaces: [MapPlace] = []
    var placeArray: [MapPlace] = []
    let query = 5
    
    func popularPlaces(completion: @escaping () -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.popularPlaces(limit: query)) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let data):
                self.popularPlaces = data.data.places
                completion()
            case .failure(let error):
                print("Error!:\(error)")
            }
        }
    }

    func lastPlaces(completion: @escaping () -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.lastPlaces(limit: query)) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let data):
                self.lastPlaces = data.data.places
                completion()
            case .failure(let error):
                print("Error!:\(error)")
            }
        }
    }

    func userPlaces(completion: @escaping () -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.lastPlaces(limit: query)) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let data):
                self.userPlaces = data.data.places
                completion()
            case .failure(let error):
                print("Error!:\(error)")
            }
        }
    }
    
}
