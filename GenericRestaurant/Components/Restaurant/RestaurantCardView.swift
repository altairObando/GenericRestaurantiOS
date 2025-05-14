//
//  RestaurantCardView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//

import SwiftUI
struct RestaurantCardView: View {
    var restaurant: Restaurant;
    var onSelect: (Restaurant) -> Void
    @State private var isPressed: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack(alignment: .center, spacing: 8){
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                Text(restaurant.name ?? String())
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            Text(restaurant.description ?? String())
                .font(.subheadline)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
            Text(restaurant.address ?? String())
                .font(.subheadline)
                .tint(Color.gray)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
        }.padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 160)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
        .onTapGesture {
            isPressed.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed.toggle()
                onSelect(restaurant);
            }
        }
    }
}
