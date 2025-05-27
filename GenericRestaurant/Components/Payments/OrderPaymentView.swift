//
//  OrderPaymentView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/27/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct OrderPaymentsView: View {
    let orderId: Int
    @State private var payments: [SplitPayment] = []
    @State private var isLoading = false
    @State private var showAddPayment = false

    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView("Loading payments...")
            } else if payments.isEmpty {
                Text("No payments found.")
                    .foregroundColor(.gray)
            } else {
                List(payments) { payment in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(payment.paymentMethod).bold()
                            Spacer()
                            Text("$\(payment.amountPaidByCustomer)").bold()
                        }
                        if let reference = payment.reference, !reference.isEmpty {
                            Text("Ref: \(reference)").font(.caption)
                        }
                        if payment.changeDue != "0.00" {
                            Text("Change: $\(payment.changeDue)").font(.caption).foregroundColor(.green)
                        }
                        if payment.isRefunded {
                            Text("Refunded").font(.caption2).foregroundColor(.red)
                        }
                    }.padding(.vertical, 4)
                }
            }

            Spacer()

            Button("Add Payment", systemImage: "plus") {
                showAddPayment = true
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)

        }
        .padding()
        .navigationTitle("Payments")
        .onAppear {
            fetchPayments()
        }
        .navigationDestination(isPresented: $showAddPayment) {
            AddSplitPaymentView(orderId: orderId) { success in
                if success {
                    showAddPayment = false
                    fetchPayments()
                }
            }
        }
    }

    func fetchPayments() {
        isLoading = true
        Task{
            do{
                let result = try await APIService.shared.getSplitPayments(orderId: orderId);
                payments = result;
            }catch{
                print("Error loading payments: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
}
