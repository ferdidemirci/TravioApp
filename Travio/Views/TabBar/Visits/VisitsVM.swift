//
//  VisitsVM.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import KeychainSwift
import Alamofire

class VisitsVM {
    typealias closure = (() -> Void)?
    var visits: [Visit] = []
    let keychain = KeychainSwift()
    
    func getVisits(complate: closure) {
        NetworkHelper.shared.routerRequest(request: Router.allVisit) { (result: Result<VisitsResponse, Error> ) in
            switch result {
            case .success(let data):
                self.visits = data.data.visits
                complate!()
            case .failure(let error):
                complate!()
            }
            
        }
    }
}
    

