//
//  AddItemDetail.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/23/25.
//

import SwiftUI

struct AddItemDetail: View {
    @Binding var order: Order
    @State private var showSearch: Bool = false
    @State var product: Pricing? = nil
    @State var price: String = "0.00"
    @State var quantity: String = "1"
    @State var orderNotes: String = ""
    @State var isLoading: Bool = false;
    var onCreate: ((_ success: Bool, _ message: String) -> Void)?
    var finalPrice: Double {
        let qty = Double(quantity) ?? 0
        let prc = Double(price) ?? 0
        return qty * prc
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Item")
                        .font(.largeTitle.bold())
                    Text("Order #\(order.id)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                // Product Section
                GroupBox(label: Label("Product", systemImage: "cart.badge.plus")) {
                    if let pro = product {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(pro.productName)
                                .font(.headline)
                            Button("Change Product", systemImage: "magnifyingglass") {
                                showSearch.toggle()
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                    } else {
                        Button {
                            showSearch.toggle()
                        } label: {
                            Label("Search a product...", systemImage: "magnifyingglass")
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                    }
                }
                // Pricing and Quantity
                GroupBox(label: Label("Details", systemImage: "slider.horizontal.3")) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Price:")
                            Spacer()
                            TextField("Price", text: $price)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                        }
                        HStack {
                            Text("Quantity:")
                            Spacer()
                            TextField("Quantity", text: $quantity)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                        }
                        HStack {
                            Text("Total:")
                            Spacer()
                            Text("Total: \(String(format: "%.2f", finalPrice))")
                        }
                    }
                    .padding(.top, 4)
                }
                // Notes
                GroupBox(label: Label("Order Notes", systemImage: "note.text")) {
                    TextEditor(text: $orderNotes)
                        .frame(minHeight: 100)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                        )
                }
                // Add Button
                Button(action: {
                    addNewItem()
                }) {
                    Label("Add Item to Order", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 10)
                .disabled(isLoading)
            }
            .padding()
        }
        .navigationTitle("Add Item")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showSearch){
            if let restaurantId = order.restaurant{
                PricingList(restaurantId: restaurantId){ price in
                    self.product = price;
                    self.price = price.price;
                    self.showSearch = false
                }
            } else {
                Text("Failed to get restaurant ID")
            }
        }
    }
    func addNewItem(){
        Task{
            do{
                isLoading = true;
                let newItem = OrderDetailsSet(
                    id: 0,
                    itemPrice: price,
                    total: String(finalPrice),
                    quantity: Int(quantity),
                    order: order.id,
                    item: product?.productId ?? 0,
                    productName: ""
                )
                _ = try await APIService.shared.addOrderDetail(
                    order.id,
                    newItem
                )
                isLoading = false;
                onCreate?( true, "Created")
            }catch{
                print(error.localizedDescription);
                DispatchQueue.main.async {
                    isLoading = false;
                    onCreate?( false, error.localizedDescription)
                }
            }
        }
    }
}
