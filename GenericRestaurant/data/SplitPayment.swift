//
//  SplitPayment.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/27/25.
//

struct SplitPayment: Codable, Identifiable {
    var id: Int
    var paymentMethod: String
    var orderNumber: String
    var currency: String
    var amountPaidByCustomer: String
    var changeDue: String
    var createdAt: String?
    var updatedAt: String?
    var reference: String?
    let notes: String
    let isRefunded: Bool
    let refundedAt: String?
    let orderId: Int
    let paymentMethodId: Int
    
    enum CodingKeys: String,CodingKey {
        case id
        case paymentMethod = "payment_method_name"
        case orderNumber = "order_number"
        case currency
        case amountPaidByCustomer = "amount_paid_by_customer"
        case changeDue = "change_due"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case reference = "reference"
        case notes
        case isRefunded = "is_refunded"
        case refundedAt = "refunded_at"
        case orderId = "order"
        case paymentMethodId = "payment_method"
    }
}
