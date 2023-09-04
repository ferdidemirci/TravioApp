//
//  EditProfileVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 4.09.2023.
//

import Foundation

class EditProfileVM {
    var userInfos: Me?
    
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
    
}
