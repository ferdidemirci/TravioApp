//
//  VisitDetailsVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import Alamofire

class CustomDetailsVM {
    typealias closure = (() -> Void)
    var galleries: [Image] = []
    
    func getGallery(placeId: String, complate: @escaping closure) {
        NetworkManager.shared.routerRequest(request: Router.allGalleryByPlaceId(placeId: placeId)) { (result: Result<GalleryResponse, Error>) in
            switch result {
            case .success(let result):
                self.galleries = result.data.images
                complate()
            case .failure:break
            }
        }
    }
    
    func createVisit(placeId: String, completion: @escaping (Bool, String) -> Void) {
        let params = ["place_id": placeId,
                      "visited_at": "2023-08-10T00:00:00Z"]
        NetworkManager.shared.routerRequest(request: Router.createVisit(parameters: params)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let response):
                completion(true, response.message)
            case .failure:
                completion(false, "")
            }
        }
    }
    
    func deleteVisit(visitId: String, completion: @escaping (Bool, String) -> Void) {
        NetworkManager.shared.routerRequest(request: Router.deleteVisitById(visitId: visitId)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                completion(true, data.message)
            case .failure:
                completion(false, "")
            }
        }
    }
    
    func deletePlace(placeId: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.routerRequest(request: Router.deletePlace(placeId: placeId)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let response):
                if response.status == "success" {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure: break
            }
        }
    }
    
    func getVisitByPlaceId(placeId: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.routerRequest(request: Router.getVisitByPlaceId(placeId: placeId)) { (result: Result<Response, Error>) in
            switch result{
            case .success(let response):
                if response.status == "success" {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure: break
            }
        }
    }
    
    func getCellCount() -> Int {
        return galleries.count
    }
    
    func getImage(index: Int) -> Image {
        return galleries[index]
    }
}
