//
//  Profile.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import Foundation
import SwiftData

struct Profile: Codable {
    let id: Int?
    let contact: Contact?
    let role: String?
    let user, owner: Int?
    let activeLocation: String?
    enum CodingKeys: String, CodingKey {
        case id, contact, role, user, owner
        case activeLocation
    }
}