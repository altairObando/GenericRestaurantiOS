//
//  DetailHeader.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/19/25.
//

import SwiftUI
struct DetailHeader: View {
    let orderId: Int
    let orderStatus: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Order #\(orderId)")
                .font(.title2)
                .bold()
            Text("Status: \(orderStatus)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
