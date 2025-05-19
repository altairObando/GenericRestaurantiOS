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
    @State private var nextOrderUrl: String? = nil;
    
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
                        ForEach(orders.indices, id: \.self) { index in
                            let order = orders[index]
                            NavigationLink(destination: OrderDetailView(orderId: order.id)){
                                OrderCardView(order: order)
                                .onAppear{
                                    if index == orders.count - 1 {
                                        fetchMoreOrders()
                                    }
                                }
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
                    self.nextOrderUrl = paginated.next;
                case .failure:
                    print("Error fetching orders")
            }
            isLoading = false;
        }
    }
    func fetchMoreOrders(){
        Task{
            if nextOrderUrl == nil { return }
            guard let url = nextOrderUrl, !isLoading else { return }
            isLoading = true;
            let response: PaginatedResult<[Order]> = try await APIService.shared.requestAsync(
                url: URL(string: url)!
            );
            self.nextOrderUrl = response.next;
            self.orders.append(contentsOf: response.results);
            isLoading.toggle()
        }
    }
}
