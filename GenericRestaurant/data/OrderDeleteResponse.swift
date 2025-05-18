//
//  OrderDeleteResponse.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/18/25.
//

import Foundation
struct OrderDeleteResponse: Codable {
    var message: String?
    var deletedItem: DeletedOrder?
    var orderId: String?
    var error: String?
    var detail: String?
    enum CodingKeys: String, CodingKey {
        case message = "message";
        case deletedItem = "deleted_item"
        case orderId = "order_id"
        case error = "error";
        case detail = "detail"
    }
}
struct DeletedOrder: Codable{
    var id: Int
    let itemName: String
    let quantity: Int
    let itemPrice: Double
    let total: Double
    enum CodingKeys: String, CodingKey {
        case id = "id";
        case itemName = "item_name";
        case quantity = "quantity";
        case itemPrice = "item_price";
        case total = "total"
    }
}
