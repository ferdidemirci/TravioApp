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
                print(data)
                complate!()
            case .failure(let error):
                print("1----------\(error.localizedDescription)")
                complate!()
            }
            
        }
    }
}
    
    
    
//    Eski yöntem Router kullanmadan
//    func getData(complate: closure) {
//        let url = EndPoint.listTravel.apiURL
//
//        guard let accessToken = keychain.get("accessTokenKey") else { return}
//        print("1-\(accessToken)")
//        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
//
//        NetworkingHelper.shared.getVisits(from: url, method: .get, header: headers) { (result:Result<ResponseData, Error>) in
//            switch result {
//            case .success(let data):
//                self.visits = data.data.travels
//                print("2-Travelid-----------------\(self.visits)")
//                complate!()
//            case .failure(let error):
//                print("Hata!!!!!\(error)")
//            }
//        }
//    }
//}
