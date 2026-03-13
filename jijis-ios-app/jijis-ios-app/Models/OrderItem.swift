//
//  OrderItem.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// A lightweight, backend-ready representation of a cart item at order time.
/// Flattened from CartItem so it does not carry the full MenuItem graph.
///
/// TODO: Future — add customizations: [String] (e.g. "extra butter")
/// TODO: Future — add orderNotes: String
struct OrderItem: Encodable {
    let menuItemId: UUID
    let name: String
    let price: Double
    let quantity: Int

    var lineTotal: Double { price * Double(quantity) }
}

extension OrderItem {
    /// Convenience initialiser — converts a CartItem into an OrderItem.
    init(from cartItem: CartItem) {
        self.menuItemId = cartItem.menuItem.id
        self.name       = cartItem.menuItem.name
        self.price      = cartItem.menuItem.price
        self.quantity   = cartItem.quantity
    }
}
