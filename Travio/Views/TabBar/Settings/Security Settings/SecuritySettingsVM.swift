//
//  SecuritySettingsVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 5.09.2023.
//

import Foundation

class SecuritySettingsVM {
    let sectionTitles = ["Change Password", "Privacy"]
    let cellTitles = [["New Password", "New Password Confirm"], ["Camera", "Photo Library", "Location"]]
    
    func changePassword(newPassword: String) {
        NetworkHelper.shared.routerRequest(request: Router.changePassword(parameters: ["new_password": newPassword])) { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                print("Change Password: \(data)")
            case .failure(let error):
                print("Edit Profile Error: \(error.localizedDescription)")
            }
        }
    }
}