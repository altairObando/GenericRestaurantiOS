//
//  OrderList.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/15/25.
//

import SwiftUI
struct OrderList: View {
    @Binding var isLoggedIn: Bool
    @State private var orders: [Order] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("My Orders").font(.headline)
                Spacer()
                Button{
                    print("Create Order")
                } label: {
                    Image(systemName: "plus")
                }.buttonStyle(.borderless)
            }.padding()
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
                            OrderCardView(order: order)
                        }
                    }.padding()
                }.refreshable {
                    fetchOrders()
                }
            }
        }
        .onAppear{
            if orders.isEmpty {
                fetchOrders()
            }
        }
    }
    func fetchOrders(){
        isLoading = true;
        APIService.shared.getOrders(){ result in
            switch result {
                case .success(let paged):
                    self.orders = paged.results
                case .failure:
                    print("Error fetching orders")
            }
            isLoading = false;
        }
    }
}
