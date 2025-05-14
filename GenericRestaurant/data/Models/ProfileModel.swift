//
//  ProfileModel.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//


import Foundation
import SwiftData

@Model
class ProfileModel {
    var role: String?
    var activeLocation: String?
    var contact: ContactModel?

    init(role: String?, activeLocation: String?, contact: ContactModel?) {
        self.role = role
        self.activeLocation = activeLocation
        self.contact = contact
    }
    convenience init(from profile: Profile) {
        self.init(
            role: profile.role,
            activeLocation: profile.activeLocation,
            contact: profile.contact != nil ? ContactModel(from: profile.contact!) : nil
        )
    }
}

