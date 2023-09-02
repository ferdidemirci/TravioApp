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
    
    func deleteVisit(visitId: String, complate: @escaping (String) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.deleteVisitById(visitId: visitId)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                print("Buraya girdi---:\(data)")
                complate(data.message)
            case .failure(let error):
                print("1 Hata")
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
