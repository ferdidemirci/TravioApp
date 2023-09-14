//
//  AddVisitVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import Alamofire
import UIKit

class AddVisitVM {
    
    typealias closure = (Bool) -> Void
    
    var urls: [String] = []
    var imagesData: [Data] = []

    func uploadImage(completion: @escaping closure){
        
        NetworkHelper.shared.uploadRequest(route: Router.upload(image: imagesData)) { (result: Result<UploadResponse, Error>) in
            switch result {
            case .success(let success):
                self.urls = success.urls
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func createPlace(parameters: Parameters, completion: @escaping closure) {
        NetworkHelper.shared.routerRequest(request: Router.createPlace(parameters: parameters)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                let id = data.message
                for url in self.urls {
                    self.createGallery(place_id: id, url: url)
                }
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func createGallery(place_id: String, url: String) {
        NetworkHelper.shared.routerRequest(request: Router.createGallery(parameters: ["place_id": place_id, "image_url": url])) { (result: Result<Response, Error>) in
        }
    }
}
