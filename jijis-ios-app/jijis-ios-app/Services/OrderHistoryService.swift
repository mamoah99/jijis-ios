//
//  OrderHistoryService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Defines how the app fetches a customer's past orders.
/// Lookup is by email for the prototype — no authentication required.
///
/// TODO: Future — replace email lookup with authenticated user ID
/// TODO: Future — add pagination for customers with many orders
/// TODO: Future — add func fetchOrder(id: String) for order detail screen
protocol OrderHistoryServiceProtocol {
    func fetchOrders(for email: String) async throws -> [CustomerOrder]
}
