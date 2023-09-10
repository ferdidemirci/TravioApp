//
//  EditProfileVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 4.09.2023.
//

import Foundation
import Alamofire

class EditProfileVM {
    var userInfos: Me?
    var url: [String]?
    var imageData: [Data] = []
    
    func getUserInfos(completion: @escaping (Me) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.user) { (results: Result<Me, Error>) in
            switch results {
            case .success(let data):
                self.userInfos = data
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
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
    
    func editProfile(params: Parameters) {
        NetworkHelper.shared.routerRequest(request: Router.editProfile(parameters: params)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                print("Edit Profile: \(data)")
            case .failure(let error):
                print("Edit Profile Error: \(error.localizedDescription)")
            }
        }
    }
    
}
