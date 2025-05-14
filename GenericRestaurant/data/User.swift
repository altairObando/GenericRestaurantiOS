//
//  User.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import Foundation
struct User: Codable {
    let username, email: String?
    let isSuperuser: Bool?
    let groups: [String]?
    enum CodingKeys: String, CodingKey {
        case username, email
        case isSuperuser = "is_superuser"
        case groups
    }
}
