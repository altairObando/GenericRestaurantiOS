//
//  OrderList.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/15/25.
//

import SwiftUI
struct OrderList: View {
    @Binding var isLoggedIn: Bool;
    @Binding var openNewOrder: Bool;
    @Binding var restaurant: Restaurant;
    @State private var orders: [Order] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading){
            if isLoading {
                ProgressView("Loading orders...")
            } else if orders.isEmpty {
                Text("No orders found.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(orders, id: \.id) { order in
                            NavigationLink(destination: OrderDetailView(orderId: order.id)){
                                OrderCardView(order: order)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }.padding()
                }.refreshable {
                    fetchOrders()
                }
            }
        }
        .padding()
        .onAppear{
            if orders.isEmpty {
                fetchOrders()
            }
        }
    }
    func fetchOrders(){
        isLoading = true;
        APIService.shared.getOrdersByStatus(restaurantId: restaurant.id, status: "ACTIVE" ){ result in
            switch result {
                case .success(let paginated):
                    self.orders = paginated.results;
                case .failure:
                    print("Error fetching orders")
            }
            isLoading = false;
        }
    }
}
