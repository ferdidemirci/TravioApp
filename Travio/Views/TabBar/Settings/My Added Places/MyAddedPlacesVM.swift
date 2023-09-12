//
//  MyAddedPlacesVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 12.09.2023.
//

import Foundation

class MyAddedPlacesVM {
    
    var myAddedPlaces: [Place] = []
    
    func getAllPlacesForUser(completion: @escaping (Bool) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.getAllPlacesForUser) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let value):
                self.myAddedPlaces = value.data.places
                completion(true)
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
}
