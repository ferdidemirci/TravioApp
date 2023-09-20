//
//  HomeVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 3.09.2023.
//

import Foundation

class HomeVM {
    let sectionTitles = ["Popular Places", "Last Places", "Visit Places"]
    var popularPlaces: [Place] = []
    var lastPlaces: [Place] = []
    var userPlaces: [Place] = []
    var placeArray: [Place] = []

    func fetchPlaces(for section: Sections, completion: @escaping (Bool) -> Void) {
        var request: Router
        let query = 5
        switch section {
        case .popularPlaces:
            request = Router.popularPlaces(limit: query)
        case .lastPlaces:
            request = Router.lastPlaces(limit: query)
        case .userPlaces:
            request = Router.lastPlaces(limit: query)
        }
        
        NetworkManager.shared.routerRequest(request: request) { (result: Result<MapPlaceResponse, Error>) in
            switch result {
            case .success(let data):
                switch section {
                case .popularPlaces:
                    self.popularPlaces = data.data.places
                case .lastPlaces:
                    self.lastPlaces = data.data.places
                case .userPlaces:
                    self.userPlaces = data.data.places
                }
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func sectionSelection(section: Int) {
        switch section {
        case Sections.popularPlaces.rawValue:
            placeArray = popularPlaces
        case Sections.lastPlaces.rawValue:
            placeArray = lastPlaces
        case Sections.userPlaces.rawValue:
            placeArray = popularPlaces
        default:
            break
        }
    }
}

