//
//  VisitsVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import Alamofire

class VisitsVM {
    typealias closure = ((Bool) -> Void)
    var visits: [Visit] = []
    
    func getVisits(completion: @escaping closure) {
        NetworkManager.shared.routerRequest(request: Router.allVisit) { (result: Result<VisitsResponse, Error> ) in
            switch result {
            case .success(let data):
                self.visits = data.data.visits
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
