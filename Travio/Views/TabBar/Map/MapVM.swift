//
//  MapVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
class MapVM {
    
    var mapPlaces : [MapPlace] = []
    
    func getData(complation: @escaping () -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.allPlaces) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let result):
                self.mapPlaces = result.data.places
                complation()
            case .failure(let error):
                complation()
            }
        }
    }
    
    func getVisitByPlaceId(placeId: String, complation: @escaping (Bool) -> Void) {
        print("Place-------: \(placeId)")
        NetworkHelper.shared.routerRequest(request: Router.getVisitByPlaceId(placeId: placeId)) { (result: Result<Response, Error>) in
            print(result)
            switch result {
            case .success:
                complation(false)
            case .failure:
                complation(true)
            }
        }
    }
}
