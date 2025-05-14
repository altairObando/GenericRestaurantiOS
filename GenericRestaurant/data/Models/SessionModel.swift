//
//  SessionModel.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//


import Foundation
import SwiftData

@Model
class SessionModel {
    @Attribute(.unique) var id: String = UUID().uuidString
    var user: UserModel
    var profile: ProfileModel

    init(user: UserModel, profile: ProfileModel) {
        self.user = user
        self.profile = profile
    }
    convenience init(from authResponse: AuthResponse) {
        self.init(
            user: UserModel(from: authResponse.user),
            profile: ProfileModel(from: authResponse.profile)
        )
    }
}
