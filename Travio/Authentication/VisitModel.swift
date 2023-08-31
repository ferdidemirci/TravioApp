//
//  UserModel.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation

struct Visit: Codable {
    let id: String
    let place_id: String
    let visited_at: String
    let created_at: String
    let updated_at: String
    let place: VisitPlace
}

struct VisitPlace: Codable {
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

struct VisitsResponse: Codable {
    let data: DataContainer
    let status: String
}

struct DataContainer: Codable {
    let count: Int
    let visits: [Visit]
}
