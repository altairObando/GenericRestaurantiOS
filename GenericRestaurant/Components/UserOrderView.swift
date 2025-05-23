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
    @State private var orderStatus : OrderStatus = .ACTIVE
    @State private var selectedTab: Tab = .orders
    @State private var showLocationSelect: Bool = false
    @State private var showOrder: Bool = false;
    @State private var newOrderId: Int = 0;
    
    var body: some View {
        TabView(selection: $selectedTab ) {
            OrderList(
                orderStatus: $orderStatus,
                isLoggedIn: $isLoggedIn,
                restaurant: $restaurant
            )
            .tabItem {
                Label("Orders", systemImage: "list.bullet")
            }.tag(Tab.orders)
            OrderHistory(isLoggedIn: $isLoggedIn, restaurant: $restaurant )
            .tabItem {
                Label("Order History", systemImage: "calendar.badge.clock")
            }.tag(Tab.history)
            Text("Profile").tabItem {
                Label("Profile", systemImage: "person")
            }.tag(Tab.settings)
        }
        .navigationTitle(
            selectedTab == .orders  ? "My Orders" :
            selectedTab == .history ? "Order History": "Profile")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    showLocationSelect.toggle()
                }label:{
                    Text("New Order")
                }.buttonStyle(.borderless)
                .animation(.easeInOut, value: selectedTab != .orders)
                .hiddenConditionally(isHidden: selectedTab != .orders)
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(String(), systemImage: "calendar.badge.clock"){
                    print("Pick Date")
                }.hiddenConditionally(isHidden: selectedTab != .history)
            }
            
        }.navigationDestination(isPresented: $showLocationSelect){
            LocationView(restaurantId: $restaurant.id, openNewOrder: $showLocationSelect, newOrderId: $newOrderId , showOrder: $showOrder)
        }.navigationDestination(isPresented: $showOrder){
            if newOrderId > 0{
                OrderDetailView(orderId: newOrderId)
            }else{
                Text("Order Id Not Found")
            }
        }
    }
}
extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
}
