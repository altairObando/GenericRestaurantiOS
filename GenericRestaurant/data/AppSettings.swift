//
//  AppSettings.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import Foundation

struct AppSettings: Codable {
    var currency: String
    var taxRate: Double
    var orderStatuses, paymentMethods: [String]?
    var tableManagementEnabled, reservationEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case currency
        case taxRate
        case orderStatuses
        case paymentMethods
        case tableManagementEnabled
        case reservationEnabled
    }
}
