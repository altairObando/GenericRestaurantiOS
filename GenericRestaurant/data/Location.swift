//
//  Location.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import Foundation

struct Location: Codable {
    var id: Int
    var sublocations: [Location]?
    // location name
    var location: String
    var createdAt, updatedAt: Date?
    var restaurant: Int
    var parent: Int?

    enum CodingKeys: String, CodingKey {
        case id, sublocations, location
        case createdAt
        case updatedAt
        case restaurant, parent
    }
}