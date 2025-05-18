//
//  UserOrderView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import SwiftUI

struct UserOrderView: View {
    @Binding var isLoggedIn: Bool;
    @Binding var restaurant: Restaurant;
    enum Tab { case orders, history, settings }
    @State private var selectedTab: Tab = .orders
    @State private var openNewOrder: Bool = false
    var body: some View {
        TabView(selection: $selectedTab ) {
            OrderList(isLoggedIn: $isLoggedIn, openNewOrder: $openNewOrder, restaurant: $restaurant  ).tabItem {
                Label("Orders", systemImage: "list.bullet")
            }.tag(Tab.orders)
            Text("Order History").tabItem {
                Label("History", systemImage: "clock")
            }.tag(Tab.history)
            Text("Profile").tabItem {
                Label("Profile", systemImage: "person")
            }.tag(Tab.settings)
        }
        .navigationTitle(
            selectedTab == .orders  ? "My Orders" :
            selectedTab == .history ? "Order History": "Profile")
        .toolbar{
            Button{
                openNewOrder.toggle()
            }label:{
                Text("New Order")
            }.buttonStyle(.borderless)
            .animation(.easeInOut, value: selectedTab != .orders)
            .hiddenConditionally(isHidden: selectedTab != .orders)
            
        }
        .navigationDestination(isPresented: $openNewOrder){
            Text("New Order Form")
        }
    }
}
extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
}
