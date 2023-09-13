//
//  EditProfileVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 4.09.2023.
//

import Foundation
import Alamofire

class EditProfileVM {
    
    var url: [String]?
    var imageData: [Data] = []
    
    func uploadImage(completion: @escaping () -> Void){
        NetworkHelper.shared.uploadRequest(route: Router.upload(image: imageData)) { (result: Result<UploadResponse, Error>) in
            switch result {
            case .success(let success):
                self.url = success.urls
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func editProfile(params: Parameters, completion: @escaping (Bool, String) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.editProfile(parameters: params)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                completion(true, data.message)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
}
