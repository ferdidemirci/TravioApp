//
//  SettingsVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 31.08.2023.
//

import Foundation

class SettingsVM {
    var userInfos: Me?
    var settingsParameters: [SettingsModel] = [SettingsModel(leftImage: "user", text: "Security Settings"),
                                               SettingsModel(leftImage: "scope", text: "App Defaults"),
                                               SettingsModel(leftImage: "mapIcon", text: "My Added Places"),
                                               SettingsModel(leftImage: "headphone", text: "Help&Support"),
                                               SettingsModel(leftImage: "info", text: "About"),
                                               SettingsModel(leftImage: "termsofuse", text: "Terms of Use")]
    
    func getUserInfos(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.routerRequest(request: Router.user) { (results: Result<Me, Error>) in
            switch results {
            case .success(let data):
                self.userInfos = data
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func deleteTokens(completion: @escaping (Bool) -> Void) {
        let accessTokenDeleted = KeychainManager.shared.deleteValue(forKey: "accessTokenKey")
        let refreshTokenDeleted = KeychainManager.shared.deleteValue(forKey: "refreshTokenKey")
        
        completion(accessTokenDeleted && refreshTokenDeleted)
    }
}
