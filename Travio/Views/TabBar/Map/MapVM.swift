//
//  MapVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
class MapVM {
    
    var mapPlaces : [Place] = []
    
    func getData(complation: @escaping () -> Void) {
        NetworkManager.shared.routerRequest(request: Router.allPlaces) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let result):
                self.mapPlaces = result.data.places
                complation()
            case .failure:
                complation()
            }
        }
    }
}
