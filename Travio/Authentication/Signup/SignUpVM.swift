//
//  SignUpVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import Alamofire

class SignUpVM {
    
    func postData(_ userModel: User, completion: @escaping () -> Void) {
        let params = ["full_name": "\(userModel.full_name)",
                      "email": "\(userModel.email)",
                      "password": "\(userModel.password)"]
        NetworkHelper.shared.routerRequest(request: Router.signIn(parameters: params)) { (result: Result<Response, Error>) in
            switch result {
            case .success(let response):
                completion()
            case .failure(let error):
                completion()
            }
        }
    }
    
    
//    func getData(_ model: User, completion: @escaping () -> Void) {
//        let apiURL = EndPoint.register.apiURL
//        let params = ["full_name": "\(model.full_name)",
//                      "email": "\(model.email)",
//                      "password": "\(model.password)"]
//        NetworkingHelper.shared.objectRequest(from: apiURL, params: params, method: .post) { (result: Result<Response, Error>) in
//            switch result {
//            case .success(let response):
//                print("Eklendi")
//                print(response)
//                completion()
//            case .failure(let err):
//                print("1")
//                print(err.localizedDescription)
//            }
//        }
//    }
}
