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
    
    typealias closure = () -> Void
    
    var urls: [String] = []
    var images: [UIImage] = []

    func createPlace(parameters: Parameters, complate: @escaping closure) {
        NetworkHelper.shared.routerRequest(request: Router.createPlace(parameters: parameters)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                let id = data.message
                for url in self.urls {
                    self.createGallery(place_id: id, url: url)
                }
                complate()
            case .failure(let error):
                print("Error")
            }
        }
    }
    
    func createGallery(place_id: String, url: String) {
        NetworkHelper.shared.routerRequest(request: Router.createGallery(parameters: ["place_id": place_id, "image_url": url])) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                print("Create Gallery: \(data)")
            case .failure(let error):
                print("Create Gallery Error: \(error.localizedDescription)")
            }
        }
    }
    
    func upload(image: [Data], completion: @escaping closure){
        
    }
    
    func uploadPhotoToAPI(complate: @escaping () -> Void) {
        let uploadURL = "https://api.iosclass.live/upload"
        var uploadCount = 0
        for image in images {
            AF.upload(
                multipartFormData: { multipartFormData in
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "file/jpeg")
                    }
                },
                to: uploadURL,
                method: .post
            )
            .responseJSON { response in
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let responseModel = try decoder.decode(UploadResponse.self, from: data)
                        let url = responseModel.urls[0]
                        self.urls.append(url)
                        uploadCount += 1
                        if uploadCount == self.images.count {
                            complate()
                        }
                    } catch let error {
                        print("Decoding Error:", error)
                    }
                }
            }
        }
    }
}
