//
//  OrderCardView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/15/25.
//

import SwiftUI

struct OrderCardView: View {
    var order: Order
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order #\(order.id)")
                    .font(.headline)
                Spacer()
                Text(order.orderStatus?.capitalized ?? "Unknown")
                    .font(.subheadline)
                    .foregroundColor(statusColor(for: order.orderStatus))
                    .padding(6)
                    .background(statusColor(for: order.orderStatus).opacity(0.1))
                    .cornerRadius(8)
            }

            if let created = order.createdAt {
                Text("Created: \(formatDate(created))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Divider()

            HStack {
                VStack(alignment: .leading) {
                    Text("Subtotal: $\((Float(order.subtotal ?? "") ?? 0).formatted())")
                    Text("Taxes: $\((Float(order.taxes ?? "") ?? 0).formatted())")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Total:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$\((Float(order.total ?? "") ?? 0).formatted())")
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }

    // Status color mapping
    func statusColor(for status: String?) -> Color {
        switch status?.lowercased() {
            case "paid": return .green
            case "pending": return .orange
            case "active": return .yellow
            case "reserved": return .blue
            case "cancelled": return .red
            default: return .gray
        }
    }
}
