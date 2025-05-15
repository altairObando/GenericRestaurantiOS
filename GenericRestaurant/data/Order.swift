//
//  Order.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/15/25.
//


import Foundation

struct Order: Codable {
    var id: Int
    var orderDetailsSet: [OrderDetailsSet]?
    var orderStatus, createdAt, updatedAt: String?
    var taxes, subtotal, total: String?
    var restaurant, location, waiter: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case orderDetailsSet = "OrderDetails_set"
        case orderStatus = "order_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case subtotal, taxes, total, restaurant, location, waiter
    }
}
