//
//  CustomerOrder.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Represents a single order row fetched from the Orders tab in Google Sheets.
///
/// TODO: Future — add orderStatus: String (e.g. "pending", "ready", "completed")
/// TODO: Future — parse items JSON string into a typed array for richer display
/// TODO: Future — add cancellationDeadline: Date for cancellation rules
struct CustomerOrder: Decodable {
    let confirmationId: String
    let customerName: String?   // not returned by current backend
    let customerEmail: String?  // not returned by current backend
    let pickupDate: String
    let pickupWindow: String
    let subtotal: Double?       // not returned by current backend
    let tipAmount: Double?      // not returned by current backend
    let total: Double
    let paymentMethod: String
    let createdAt: String       // backend key; was submittedAt
    let items: String?          // not returned by current backend

    enum CodingKeys: String, CodingKey {
        case confirmationId, customerName, customerEmail
        case pickupDate, pickupWindow
        case subtotal, tipAmount, total, paymentMethod
        case createdAt
        case items
    }
}

extension CustomerOrder: Identifiable {
    var id: String { confirmationId }
}

extension CustomerOrder {
    /// Best-effort display summary extracted from the raw items JSON string.
    /// Returns something like "Classic Salt Bread + 1 more" or falls back gracefully.
    var itemSummary: String {
        guard
            let data = items?.data(using: .utf8),
            let parsed = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
            let first = parsed.first,
            let firstName = first["name"] as? String
        else {
            return "Order details unavailable"
        }

        let remaining = parsed.count - 1
        if remaining > 0 {
            return "\(firstName) + \(remaining) more"
        }
        return firstName
    }
}
