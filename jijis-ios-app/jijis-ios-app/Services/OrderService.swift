//
//  OrderService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Defines how the app submits a preorder.
///
/// TODO: Future — implement with real API (POST /orders)
/// TODO: Future — trigger confirmation email from backend on success
/// TODO: Future — integrate Stripe PaymentIntent before calling submitOrder
/// TODO: Future — add func cancelOrder(id: String) for order management
protocol OrderServiceProtocol {
    func submitOrder(_ request: OrderRequest) async throws -> OrderConfirmation
}
