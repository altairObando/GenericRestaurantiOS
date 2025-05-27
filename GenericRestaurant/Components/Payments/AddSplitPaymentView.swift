//
//  AddSplitPaymentView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/27/25.
//

import SwiftUI

struct AddSplitPaymentView: View {
    let orderId: Int
    var onDone: (Bool) -> Void
    @State private var paymentMethods: [PaymentMethod] = []
    @State private var selectedMethodId: Int?
    @State private var amountPaid = ""
    @State private var reference = ""
    @State private var notes = ""
    @State private var isLoading = false

    var body: some View {
        Form {
            Section(header: Text("Payment Method")) {
                Picker("Select method", selection: $selectedMethodId) {
                    ForEach(paymentMethods.filter { $0.isActive }) { method in
                        Text(method.name).tag(method.id)
                    }
                }
            }

            Section(header: Text("Amount Paid (USD)")) {
                TextField("0.00", text: $amountPaid)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Reference (optional)")) {
                TextField("Transaction reference", text: $reference)
            }

            Section(header: Text("Notes (optional)")) {
                TextField("Any notes", text: $notes)
            }

            Button("Submit Payment") {
                Task {
                    await submitPayment()
                }
            }
            .disabled(selectedMethodId == nil || amountPaid.isEmpty)
        }
        .navigationTitle("Add Payment")
        .onAppear {
            fetchPaymentMethods()
        }
    }

    func fetchPaymentMethods() {
        APIService.shared.getPaymentMethods { result in
            switch result {
                case .success(let methods):
                    self.paymentMethods = methods;
                    if selectedMethodId == nil, let first = methods.first(where: { $0.isActive }) {
                        selectedMethodId = first.id
                    }
                case .failure(let error):
                    print("Failed to load methods: \(error.localizedDescription)")
            }
        }
    }

    func submitPayment() async {
        guard let methodId = selectedMethodId else { return }
        let payment = SplitPayment(
            id: 0,
            paymentMethod: "", // server sets this
            orderNumber: "",   // server sets this
            currency: "USD",
            amountPaidByCustomer: amountPaid,
            changeDue: "0.00", // server can calculate
            createdAt: nil,
            updatedAt: nil,
            reference: reference,
            notes: notes,
            isRefunded: false,
            refundedAt: nil,
            orderId: orderId,
            paymentMethodId: methodId
        )
        do {
            let _: SplitPayment = try await APIService.shared.addSplitPayment(orderId: orderId, payment: payment)
            onDone(true)
        } catch {
            print("Failed to submit: \(error.localizedDescription)")
            onDone(false)
        }
    }
}
