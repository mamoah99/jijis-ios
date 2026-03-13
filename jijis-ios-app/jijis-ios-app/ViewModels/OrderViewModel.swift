//
//  OrderViewModel.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation
import Combine

@MainActor
class OrderViewModel: ObservableObject {
    @Published var isSubmitting = false
    @Published var confirmation: OrderConfirmation? = nil
    @Published var errorMessage: String? = nil

    func submit(_ request: OrderRequest, using service: OrderServiceProtocol) async {
        isSubmitting = true
        errorMessage = nil
        do {
            confirmation = try await service.submitOrder(request)
        } catch {
            errorMessage = "Something went wrong placing your order. Please try again."
        }
        isSubmitting = false
    }
}
