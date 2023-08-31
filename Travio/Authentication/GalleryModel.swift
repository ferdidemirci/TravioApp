//
//  UserModel.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation

struct GalleryResponse: Codable {
    let data: DataInfo
    let status: String
}

struct DataInfo: Codable {
    let images: [Image]
    let count: Int
}

struct Image: Codable {
    let id: String
    let place_id: String
    let image_url: String
    let created_at: String
    let updated_at: String
}
