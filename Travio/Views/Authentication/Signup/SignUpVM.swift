//
//  SignUpVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import Alamofire

class SignUpVM {
    
    func postData(_ userModel: User, completion: @escaping (Bool) -> Void) {
        let params = ["full_name": "\(userModel.full_name)",
                      "email": "\(userModel.email)",
                      "password": "\(userModel.password)"]
        NetworkManager.shared.routerRequest(request: Router.signIn(parameters: params)) { (result: Result<Response, Error>) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

}
