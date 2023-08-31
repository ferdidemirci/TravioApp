//
//  UserModel.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation

struct UploadResponse: Codable {
    let message: String
    let messageType: String
    let urls: [String]
}
