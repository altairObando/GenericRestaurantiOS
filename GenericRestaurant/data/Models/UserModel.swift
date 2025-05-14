//
//  UserModel.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//

import Foundation
import SwiftData

@Model
class UserModel {
    @Attribute(.unique) var id: String = UUID().uuidString
    var username: String
    var email: String
    var isSuperuser: Bool
    var groups: [String]

    init(username: String, email: String, isSuperuser: Bool, groups: [String]) {
        self.username = username
        self.email = email
        self.isSuperuser = isSuperuser
        self.groups = groups
    }
    convenience init(from user: User) {
        self.init(
            username: user.username ?? "",
            email: user.email ?? "",
            isSuperuser: user.isSuperuser ?? false,
            groups: user.groups ?? []
        )
    }
}
