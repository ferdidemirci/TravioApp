//
//  Router.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import Alamofire
import KeychainSwift

public enum Router: URLRequestConvertible {
    
    case login(parameters: Parameters)
    case signIn(parameters: Parameters)
    case placeById(placeId: String)
    case allPlaces
    case allGalleryByPlaceId(placeId: String)
    case createVisit(parameters:Parameters)
    case allVisit
    case createPlace(parameters: Parameters)
    case createGallery(parameters: Parameters)
    case upload(image: [Data])
    
    var accessToken: String {
        guard let accessToken = KeychainSwift().get("accessTokenKey") else { return "" }
        return accessToken
    }
    
    var baseURL: URL {
        return URL(string: "https://api.iosclass.live")!
    }
    
    private var method: HTTPMethod {
        switch self {
        case .login, .signIn, .createVisit, .createPlace, .createGallery, .upload:
            return .post
        case .placeById, .allPlaces, .allGalleryByPlaceId, .allVisit:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/v1/auth/login"
        case .signIn:
            return "/v1/auth/register"
        case .placeById(let placeId):
            return "/v1/galleries/\(placeId)"
        case .allPlaces:
            return "/v1/places"
        case .allGalleryByPlaceId(let placeId):
            return "/v1/galleries/\(placeId)"
        case .createVisit, .allVisit:
            return "/v1/visits"
        case .createPlace:
            return "/v1/places"
        case .createGallery:
            return "/v1/galleries"
        case .upload:
            return "/upload"
        }
    }
    
    private var parameters: Parameters {
        switch self {
        case .login(let parameters), .signIn(let parameters), .createVisit(let parameters), .createPlace(let parameters), .createGallery(let parameters):
            return parameters
        case .placeById, .allPlaces, .allGalleryByPlaceId, .allVisit, .upload:
            return [:]
        }
    }
    
    private var headers: HTTPHeaders {
        switch self {
        case .login, .signIn, .allPlaces, .allGalleryByPlaceId, .upload:
            return [:]
        case .placeById, .createVisit, .allVisit, .createPlace, .createGallery:
            return ["Authorization": "Bearer \(accessToken)"]
        case .upload:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var multipartFormData: MultipartFormData {
        let formData = MultipartFormData()
        switch self {
        case .upload(let imageData):
            imageData.forEach { image in
                formData.append(image, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            return formData
        default:
            break
        }
        return formData
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        
        let encoding: ParameterEncoding = {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }()
    return try encoding.encode(urlRequest, with: parameters)
    }
}