//
//  OrderRequest.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// The full payload sent to OrderService when the customer places a preorder.
///
/// TODO: Future — encode as JSON and POST to your API endpoint
/// TODO: Future — add promoCode: String? once discount logic is implemented
/// TODO: Future — add stripePaymentIntentId: String for real payment integration
struct OrderRequest: Encodable {
    let customer: CustomerInfo
    let items: [OrderItem]
    let pickupSlot: PickupSlot
    let subtotal: Double
    let tipAmount: Double
    let total: Double
    let paymentMethod: String   // "apple_pay" or "card" — mock for now
}
