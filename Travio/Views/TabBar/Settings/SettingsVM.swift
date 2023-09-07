//
//  SettingsVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 31.08.2023.
//

import Foundation
import KeychainSwift

class SettingsVM {
    var userInfos: Me?
    let keychain = KeychainSwift()
    var settingsParameters: [SettingsModel] = [SettingsModel(leftImage: "user", text: "Security Settings"),
                                               SettingsModel(leftImage: "scope", text: "App Defaults"),
                                               SettingsModel(leftImage: "mapIcon", text: "My Added Places"),
                                               SettingsModel(leftImage: "headphone", text: "Help&Support"),
                                               SettingsModel(leftImage: "info", text: "About"),
                                               SettingsModel(leftImage: "termsofuse", text: "Terms of Use")]
    
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
    
    func deleteAccessToken(completion: () -> Void) {
        let key = "accessTokenKey"
        self.keychain.delete(key)
        completion()
    }
    
}
