//
//  NetworkHelper.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import Alamofire

class NetworkHelper {
    
    static let shared = NetworkHelper()
    
    func routerRequest<T: Decodable>(request: URLRequestConvertible, callback: @escaping (Result<T, Error>) -> Void) {
        AF.request(request)
            .validate()
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                callback(.success(value))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func uploadRequest<T: Codable>(route: Router, callback: @escaping (Result<T, Error>) -> Void) {
        let request: URLRequestConvertible = route
        
        AF.upload(multipartFormData: route.multipartFormData, with: request)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: value)
                        callback(.success(decodedData))
                    } catch {
                        callback(.failure(error))
                    }
                    
                case .failure(let error):
                    callback(.failure(error))
                }
            }
    }
}
