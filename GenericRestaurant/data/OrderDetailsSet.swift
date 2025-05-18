//
//  OrderDetailsSet.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/15/25.
//


import Foundation

struct OrderDetailsSet: Codable {
    var id: Int
    var itemPrice, total: String?
    var quantity: Int?
    var createdAt, updatedAt: String?
    var order, item: Int?
    var productName: String

    enum CodingKeys: String, CodingKey {
        case id
        case itemPrice = "item_price"
        case quantity, total
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case order, item
        case productName = "product_name"
    }
}
