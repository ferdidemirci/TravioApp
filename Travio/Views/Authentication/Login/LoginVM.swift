//
//  LoginVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import KeychainSwift

class LoginVM {
    
    let keychain = KeychainSwift()
    
    func postLogin(email: String, password: String, completion: @escaping () -> Void){
        NetworkHelper.shared.routerRequest(request: Router.login(parameters: ["Email": email, "Password" : password])) { (result: Result<Token, Error>) in
            switch result {
                    
            case .success(let data):
                self.keychain.set(data.accessToken, forKey: "accessTokenKey")
                print("Access Token: \(data.accessToken)")
                completion()
            case .failure(_):
                completion()
            }
        }
    }
    
}
