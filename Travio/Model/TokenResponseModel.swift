//
//  TokenResponseModel.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 14.09.2023.
//

import Foundation

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
