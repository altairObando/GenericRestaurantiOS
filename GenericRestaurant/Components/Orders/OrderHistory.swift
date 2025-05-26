//
//  OrderHistory.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/23/25.
//
import SwiftUI
enum OrderStatus: String, CaseIterable, Identifiable {
    case ACTIVE, RESERVED, DELIVERED, CANCELLED, PAID
    var id: Self { self }
}

struct OrderHistory: View {
    @State private var orderStatus: OrderStatus = .RESERVED
    @Binding var isLoggedIn: Bool;
    @Binding var restaurant: Restaurant;
    @State private var filterDate: Date = Date();
    var body: some View {
        VStack(alignment: .leading, spacing: 16 ){
            Section("Filter Options"){
                Picker("Order Status", selection: $orderStatus){
                    ForEach(OrderStatus.allCases.filter { item in item != .ACTIVE }){ status in
                        Text(status.rawValue)
                            .tag(status)
                    }
                }.pickerStyle(.segmented)
                DatePicker(
                    "Date",
                    selection: $filterDate,
                    displayedComponents: [.date]
                )
            }
            ScrollView{
                OrderList(
                    orderStatus: $orderStatus,
                    orderDate: $filterDate,
                    isLoggedIn: $isLoggedIn,
                    restaurant: $restaurant
                )
            }
        }.padding()
    }
}
