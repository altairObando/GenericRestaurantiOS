//
//  OrderDetailView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/16/25.
//
import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    @State private var order: Order?
    @State private var orderDetails: [OrderDetailsSet] = []
    @State private var selection: Set<Int> = []
    @State private var loading: Bool = true
    @State private var errMsg: String = String();
    @State private var isError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if loading{
                ProgressView()
            }
            if let order = order {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.id)")
                        .font(.title2)
                        .bold()
                    Text("Status: \(order.orderStatus?.capitalized ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Divider()
                // Info Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Location", systemImage: "mappin.and.ellipse")
                        Spacer()
                        Text(order.locationName)
                    }
                    HStack {
                        Label("Waiter", systemImage: "person")
                        Spacer()
                        Text(order.waiterName)
                    }
                    HStack {
                        Label("Created", systemImage: "calendar")
                        Spacer()
                        Text(formatDate(order.createdAt ?? String()))
                    }
                }
                .font(.subheadline)
                Divider()
                // Items
                Text("Items \((order.orderDetailsSet ?? []).count)")
                    .font(.headline)
                List(orderDetails, id: \.id, selection: $selection){ detail in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(detail.productName)
                                .font(.body)
                            Spacer()
                            Text("x\(detail.quantity ?? 0)")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Unit: $\(detail.itemPrice ?? "0")")
                            Spacer()
                            Text("Total: $\(detail.total ?? "0")")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }.padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
                .listStyle(.plain)
                Divider()
                // Totals
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text("$\(order.subtotal ?? "0")")
                    }
                    HStack {
                        Text("Taxes")
                        Spacer()
                        Text("$\(order.taxes ?? "0")")
                    }
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(order.total ?? "0")")
                            .fontWeight(.bold)
                    }
                }
                .padding(.top)
                // Options
                HStack(spacing: 16){
                    Button{
                        print("Cancel")
                    } label:{
                        FullWidthText(text: "CANCEL")
                    }.buttonStyle(.borderedProminent)
                        .tint(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Button{
                        print("Pay")
                    } label:{
                        FullWidthText(text: "PAY")
                    }.buttonStyle(.borderedProminent)
                        .tint(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }.padding(.horizontal)
            }
        }
        .padding()
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(Text("Error"), isPresented: $isError){
            Button("Ok") {
                isError.toggle()
            }
        } message: {
            Text(errMsg)
        }.onAppear{
            getOrderDetails()
        }
        .refreshable {
            getOrderDetails()
        }
        .toolbar{
            // Botón de edición para habilitar selección múltiple
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            // Botón de eliminar, visible solo si hay selección
            ToolbarItem(placement: .navigationBarTrailing) {
                if !selection.isEmpty {
                    Button {
                        deleteSelectedItems()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }

    }
    func deleteSelectedItems (){
        Task{
            var successfullyDeleted : Set<Int> = []
            do{
                for id in selection{
                    var url = APIService.shared.apiURL.appendingPathComponent( "orders/\(orderId)/remove_detail/" )
                    url.append(queryItems: [URLQueryItem(name:"detail_id", value: String(id) )])
                    let response: OrderDeleteResponse = try await APIService.shared.requestAsync(url: url,method: "DELETE")
                    let success = response.error == nil;
                    if success{
                        successfullyDeleted.insert(id)
                    }else{
                        print("Error eliminando \(id)")
                    }
                }
                // Filtra los ítems eliminados del array local
                orderDetails.removeAll { detail in
                   successfullyDeleted.contains(detail.id)
                }
                // Limpia la selección
                selection.removeAll();
                if(!successfullyDeleted.isEmpty){
                    getOrderDetails()
                }
            }
        }
    }

    func getOrderDetails(){
        loading = true;
        APIService.shared.getOrderById( orderId ) { result in
            switch result {
                case .success(let order):
                    self.order = order
                    self.orderDetails = order.orderDetailsSet ?? []
                case .failure(let error):
                    self.errMsg = error.localizedDescription
                    isError.toggle()
            }
            loading.toggle();
        }
    }
}
