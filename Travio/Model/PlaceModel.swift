//
//  UserModel.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation

struct MapPlaceResponse: Codable {
    let data: MapPlaceData
    let status: String
}

struct MapPlaceData: Codable {
    let count: Int
    let places: [Place]
}

struct Place: Codable {
    let id: String
    let creator: String
    let place: String
    let title: String
    let description: String
    let cover_image_url: String
    let latitude: Double
    let longitude: Double
    let created_at: String
    let updated_at: String
}
