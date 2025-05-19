//
//  DetailInfo.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/19/25.
//

import SwiftUI

struct DetailInfo: View {
    let locationName: String;
    let waiterName: String;
    let creationDate: String;
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Location", systemImage: "mappin.and.ellipse")
                Spacer()
                Text(locationName)
            }
            HStack {
                Label("Waiter", systemImage: "person")
                Spacer()
                Text(waiterName)
            }
            HStack {
                Label("Created", systemImage: "calendar")
                Spacer()
                Text(formatDate(creationDate))
            }
        }
        .font(.subheadline)
    }
}
