//
//  SecuritySettingsVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 5.09.2023.
//

import Foundation
import Alamofire

class SecuritySettingsVM {
    let sectionTitles = ["Change Password", "Privacy"]
    let cellTitles = [["New Password", "New Password Confirm"], ["Camera", "Photo Library", "Location"]]
    var passwords = ["Password": "", "confirmPassword": ""]
    
    func changePassword(newPassword: Parameters, completion: @escaping (Bool) -> Void) {
        NetworkHelper.shared.routerRequest(request: Router.changePassword(parameters: newPassword)) { (result: Result<Response, Error>) in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
}
