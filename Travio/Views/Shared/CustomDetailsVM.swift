//
//  VisitDetailsVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import KeychainSwift
import Alamofire

class CustomDetailsVM {
    typealias closure = (() -> Void)?
    var galleries: [Image] = []
    let keychain = KeychainSwift()
    
    func getGallery(placeId: String, complate: closure) {
        NetworkHelper.shared.routerRequest(request: Router.allGalleryByPlaceId(placeId: placeId)) { (result: Result<GalleryResponse, Error>) in
            switch result {
            case .success(let result):
                self.galleries = result.data.images
                complate!()
            case .failure(let error):
                print("Gallery Error! \(error)")
            }
        }
    }
    
    func createVisit(placeId: String, complate: @escaping (String) -> Void) {
        let params = ["place_id": placeId,
                      "visited_at": "2023-08-10T00:00:00Z"]
        NetworkHelper.shared.routerRequest(request: Router.createVisit(parameters: params)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let response):
                complate(response.message)
            case .failure(let error):
                print("Create Place: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteVisit(visitId: String, complate: @escaping (String) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.deleteVisitById(visitId: visitId)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                complate(data.message)
            case .failure(let error):
                print("Delete Visit: \(error.localizedDescription)")
            }
        }
    }
    
    func deletePlace(placeId: String, complate: @escaping (Bool) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.deletePlace(placeId: placeId)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let response):
                if response.status == "success" {
                    complate(true)
                } else {
                    complate(false)
                }
            case .failure(let error):
                print("Delete Place: \(error.localizedDescription)")
            }
        }
    }
    
    func getVisitByPlaceId(placeId: String, complation: @escaping (Bool) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.getVisitByPlaceId(placeId: placeId)) { (result: Result<Response, Error>) in
            switch result{
            case .success(let response):
                if response.status == "success" {
                    complation(true)
                } else {
                    complation(false)
                }
            case .failure(let error):
                print("Visit by Place_ID: \(error.localizedDescription)")
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
