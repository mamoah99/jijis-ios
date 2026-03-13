//
//  CartViewModel.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation
import Combine

// TODO: Future — persist cart to UserDefaults or backend between sessions
// TODO: Future — apply promo codes / discounts
// TODO: Future — integrate with checkout and payment flow
@MainActor
class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []

    var subtotal: Double {
        items.reduce(0) { $0 + $1.menuItem.price * Double($1.quantity) }
    }

    var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func add(_ menuItem: MenuItem, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(id: UUID(), menuItem: menuItem, quantity: quantity))
        }
    }

    func remove(_ cartItem: CartItem) {
        items.removeAll { $0.id == cartItem.id }
    }

    func increaseQuantity(for cartItem: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == cartItem.id }) else { return }
        items[index].quantity += 1
    }

    func decreaseQuantity(for cartItem: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == cartItem.id }) else { return }
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    func clearCart() {
        items = []
        // TODO: Future — also clear any pending order state from backend
    }
}
