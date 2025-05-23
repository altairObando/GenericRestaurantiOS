//
//  LocationItemView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/20/25.
//

import SwiftUI

struct LocationItemView: View {
    var itemId: Int;
    var itemName: String;
    var onTap: ((Int) -> Void)? = nil;
    @State private var isPressed: Bool = false;
    var body: some View {
        VStack(alignment: .center, spacing: 8){
            Image("TableIcon")
                .resizable()
                .frame(width: 100, height: 100)
            Text(itemName)
                .font(.headline)
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
                onTap?(itemId)
            }
        }
    }
}

#Preview {
    LocationItemView(itemId: 1, itemName: "TABLE NAME" )
}
