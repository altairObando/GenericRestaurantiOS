//
//  Restaurant.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import Foundation

struct Restaurant: Codable, Identifiable {
    var id: Int
    var locations: [Location]?
    var owner, name, description, address: String?
    var phone: String?
    var tags: String?
}
