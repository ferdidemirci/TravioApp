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
    
//    func getData(galleryId: String, complate: closure) {
//        print("ID::::::::::::::::::::::::::::::::-\(galleryId)")
//        let url = EndPoint.getGallery.apiURL + galleryId
//
//        guard let accessToken = keychain.get("accessTokenKey") else { return}
//        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
//
//        NetworkingHelper.shared.getVisits(from: url, method: .get, header: headers) { (result: Result<GalleryResponse, Error>) in
//            switch result {
//            case .success(let result):
//                self.galleries = result.data.images
//                complate!()
//            case .failure(let error):
//            }
//        }
//    }
    
    func getCellCount() -> Int {
        return galleries.count
    }
    
    func getImage(index: Int) -> Image {
        return galleries[index]
    }
}
