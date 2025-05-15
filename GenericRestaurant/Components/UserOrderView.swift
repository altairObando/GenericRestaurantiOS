//
//  UserOrderView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import SwiftUI

struct UserOrderView: View {
    @Binding var isLoggedIn: Bool
    var body: some View {
        TabView {
            OrderList(isLoggedIn: $isLoggedIn).tabItem {
                Label("Orders", systemImage: "list.bullet")
            }
            Text("Order History").tabItem {
                Label("History", systemImage: "clock")
            }
            Text("Profile").tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}
