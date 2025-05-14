//
//  Contact.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import Foundation
import SwiftData

struct Contact: Codable {
    let id: Int?
    let name, phoneNumber, address, email: String?
    let createdAt: String?
    let middleName, lastName, gender: String?
    let birthDate: String?
    let owner: Int?
    enum CodingKeys: String, CodingKey {
        case id, name
        case phoneNumber
        case address, email
        case createdAt
        case middleName
        case lastName
        case gender
        case birthDate
        case owner
    }
}