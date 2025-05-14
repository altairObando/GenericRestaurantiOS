//
//  ContactModel.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//


import Foundation
import SwiftData

@Model
class ContactModel {
    var name: String?
    var phoneNumber: String?
    var address: String?
    var email: String?
    var middleName: String?
    var lastName: String?
    var gender: String?

    init(name: String?, phoneNumber: String?, address: String?, email: String?, middleName: String?, lastName: String?, gender: String?) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.email = email
        self.middleName = middleName
        self.lastName = lastName
        self.gender = gender
    }
    convenience init(from contact: Contact) {
        self.init(
            name: contact.name,
            phoneNumber: contact.phoneNumber,
            address: contact.address,
            email: contact.email,
            middleName: contact.middleName,
            lastName: contact.lastName,
            gender: contact.gender
        )
    }
}
