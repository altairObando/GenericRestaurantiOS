//
//  Pricing.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/19/25.
//


import Foundation

struct Pricing: Codable, Identifiable{
    let id: Int;
    let productName: String;
    let productId: Int;
    let price: String;
    let createdOn: String?;
    let validTo: String;
    let isExtra: Bool;
    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name";
        case productId = "product";
        case price
        case createdOn = "created_on"
        case validTo   = "valid_to"
        case isExtra   = "is_extra"
    }
}
