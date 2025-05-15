//
//  InitialConfig.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//
import Foundation
struct InitialConfig: Codable {
    var user: User
    var role: String?
    var restaurants: [Restaurant]?
    var locations: [Location]?
    var menus: [String]?
    var appSettings: AppSettings?

    enum CodingKeys: String, CodingKey {
        case user, role, restaurants, locations, menus
        case appSettings
    }
}

class AppConfig {
    static let shared = AppConfig()
    var config: InitialConfig?
    public init(){
        config = InitialConfig(
            user: User(username: "", email: "", isSuperuser: false, groups: [])
        )
    }
}
