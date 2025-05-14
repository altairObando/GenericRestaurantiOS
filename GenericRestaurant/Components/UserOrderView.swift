//
//  UserOrderView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import SwiftUI
import SwiftData

struct UserOrderView: View {
    @Binding var isLoggedIn: Bool
    var body: some View {
        TabView {
            Text("Órdenes en curso")
                .tabItem {
                    Label("Órdenes", systemImage: "list.bullet")
                }
            Text("Historial")
                .tabItem {
                    Label("Historial", systemImage: "clock")
                }
        }
    }
}
