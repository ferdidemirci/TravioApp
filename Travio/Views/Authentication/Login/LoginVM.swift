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
//    Router kullanmadan
    //    func getLogin(email: String, password: String, completion: @escaping () -> Void) {
    //        let apiURL = EndPoint.login.apiURL
    //        let query = ["email": email, "password": password]
    //
    //        NetworkingHelper.shared.objectRequest(from: apiURL, params: query, method: .post) { (callBack: Result<Token, Error>) in
    //            switch callBack {
    //            case .success(let data):
    //                print("giriş yapıldı")
    //                self.keychain.set(data.accessToken, forKey: "accessTokenKey")
    //                completion()
    //            case .failure(let error):
    //                print("Hataaaaaa!")
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
}
