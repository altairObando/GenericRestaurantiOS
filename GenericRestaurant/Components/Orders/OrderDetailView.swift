//
//  OrderDetailView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/16/25.
//
import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    @State private var isEditing: Bool = false;
    @State private var order: Order = Order(id: 0)
    @State private var orderDetails: [OrderDetailsSet] = []
    @State private var selection: Set<Int> = []
    @State private var isLoading: Bool = true
    @State private var errMsg: String = String();
    @State private var isError: Bool = false
    @State private var showAddItem: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading{
                ProgressView()
            }
            if order.id > 0 {
                // Header
                DetailHeader(orderId: orderId, orderStatus: order.orderStatus ?? "Unknown" )
                Divider()
                // Info Section
                DetailInfo(locationName: (order.locationName ?? String()), waiterName: (order.waiterName ?? String()), creationDate: order.createdAt ?? String())
                Divider()
                // Items
                DetailList(orderDetails: $orderDetails, selection: $selection, loading: $isLoading, isEditing: $isEditing)
                Divider()
                // Totals
                VStack(alignment: .leading, spacing: 8) {
                    if isEditing {
                        HStack{
                            Text("Selected: \(selection.count)")
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                            Spacer()
                            Button(String(), systemImage: "trash"){
                                deleteSelectedItems()
                            }.tint(.red)
                            .disabled(selection.isEmpty)
                        }.animation(.easeInOut(duration: 0.5), value: isEditing)
                        Divider().animation(.easeInOut(duration: 0.5), value: isEditing)
                    }
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
                if !isEditing{
                    DetailOptions()
                }
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
            if !isEditing {
                // Botón de edición para habilitar selección múltiple
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("", systemImage: "pencil"){
                        isEditing.toggle()
                    }.animation(.easeInOut, value: isEditing)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("", systemImage: "plus"){
                        showAddItem.toggle()
                    }.animation(.easeInOut, value: isEditing)
                }
            }else{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done"){ isEditing.toggle()}.animation(.easeInOut, value: isEditing)
                }
            }
        }
        .navigationDestination(isPresented: $showAddItem){
            if order.id > 0 {
                AddItemDetail(order: $order){ (result: Bool, message: String) in
                    if result {
                        showAddItem.toggle()
                    }
                }
            }else{
                Text("Please select an order")
            }
        }
    }
    func deleteSelectedItems (){
        Task{
            var successfullyDeleted : Set<Int> = []
            isLoading.toggle()
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
                isEditing.toggle()
                if(!successfullyDeleted.isEmpty){
                    getOrderDetails()
                }
            }catch {
                isLoading = false
            }
        }
    }
    func getOrderDetails(){
        isLoading = true;
        APIService.shared.getOrderById( orderId ) { result in
            switch result {
                case .success(let order):
                    self.order = order
                    self.orderDetails = order.orderDetailsSet ?? []
                case .failure(let error):
                    self.errMsg = error.localizedDescription
                    isError.toggle()
            }
            isLoading.toggle();
        }
    }
}
