//
//  LoginVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation

class LoginVM {
    
    func postLogin(email: String, password: String, completion: @escaping (Bool) -> Void){
        NetworkHelper.shared.routerRequest(request: Router.login(parameters: ["Email": email, "Password" : password])) { (result: Result<Token, Error>) in
            switch result {
            case .success(let data):
                KeychainHelper.shared.saveValue(data.accessToken, forKey: "accessTokenKey")
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
}
