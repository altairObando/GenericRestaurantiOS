//
//  PaymentMethod.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/27/25.
//

struct PaymentMethod: Codable, Identifiable{
    var id: Int
    var name: String
    var isActive: Bool
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isActive = "is_active"
    }
}
