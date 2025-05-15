//
//  PaginatedResult.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/15/25.
//

import Foundation
struct PaginatedResult<T: Codable>: Codable{
    var count: Int
    var next: String?
    var previous: String?
    var results: T
}
