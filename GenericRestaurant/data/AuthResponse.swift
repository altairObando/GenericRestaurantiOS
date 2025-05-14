//
//  AuthResponse.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 4/15/25.
//

import Foundation
struct AuthResponse: Codable {
    let user: User
    let profile: Profile
    let tokens: Tokens?
}
