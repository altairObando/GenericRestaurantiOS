//
//  Product.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/19/25.
//

import Foundation
struct Product: Codable, Identifiable {
    let id: Int;
    let code: String;
    let name: String;
    let price: Double;
    let restaurant: Int;
    let category: Int
    enum CodingKeys: CodingKey {
        case id
        case code
        case name
        case price
        case restaurant
        case category
    }
}



