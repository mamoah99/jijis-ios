//
//  CurrentOrdersViewModel.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation
import Combine

@MainActor
class CurrentOrdersViewModel: ObservableObject {
    @Published var orders: [CustomerOrder] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func loadOrders(for email: String, using service: OrderHistoryServiceProtocol) async {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            orders = try await service.fetchOrders(for: email)
        } catch {
            errorMessage = "Couldn't load your orders. Please try again."
        }

        isLoading = false
    }
}
