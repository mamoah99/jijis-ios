//
//  MockOrderService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Local mock implementation of OrderServiceProtocol.
/// Simulates a successful order submission and returns a fake confirmation.
///
/// TODO: Future — replace with APIOrderService that POSTs to your backend
/// TODO: Future — trigger Stripe payment before calling backend
/// TODO: Future — backend should send confirmation email and push notification
struct MockOrderService: OrderServiceProtocol {
    func submitOrder(_ request: OrderRequest) async throws -> OrderConfirmation {
        // Simulate network latency for a realistic loading experience
        try await Task.sleep(nanoseconds: 1_200_000_000)

        // Generate a human-readable fake confirmation ID
        let confirmationId = "JIJI-\(Int.random(in: 1000...9999))"

        return OrderConfirmation(
            confirmationId: confirmationId,
            pickupDate: request.pickupSlot.date,
            pickupWindow: request.pickupSlot.timeWindow,
            total: request.total
        )
    }
}
