//
//  MockOrderHistoryService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Returns hardcoded sample orders for use in Xcode Previews.
struct MockOrderHistoryService: OrderHistoryServiceProtocol {
    func fetchOrders(for email: String) async throws -> [CustomerOrder] {
        try await Task.sleep(nanoseconds: 400_000_000)

        guard !email.isEmpty else { return [] }

        return [
            CustomerOrder(
                confirmationId: "JIJI-4821",
                customerName: "Manni Amoah",
                customerEmail: email,
                pickupDate: "Saturday, March 16",
                pickupWindow: "12:00 PM – 2:00 PM",
                subtotal: 11.00,
                tipAmount: 1.10,
                total: 12.10,
                paymentMethod: "apple_pay",
                createdAt: "2026-03-12T14:30:00Z",
                items: "[{\"name\":\"Classic Salt Bread\",\"quantity\":1},{\"name\":\"S'mores Salt Bread\",\"quantity\":1}]"
            ),
            CustomerOrder(
                confirmationId: "JIJI-3307",
                customerName: "Manni Amoah",
                customerEmail: email,
                pickupDate: "Friday, March 15",
                pickupWindow: "10:00 AM – 12:00 PM",
                subtotal: 6.50,
                tipAmount: 0,
                total: 6.50,
                paymentMethod: "card",
                createdAt: "2026-03-11T09:15:00Z",
                items: "[{\"name\":\"Truffle Egg Salad Salt Bread\",\"quantity\":1}]"
            )
        ]
    }
}
