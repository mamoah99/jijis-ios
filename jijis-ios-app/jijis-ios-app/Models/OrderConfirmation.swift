//
//  OrderConfirmation.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Returned by OrderService after a successful order submission.
///
/// TODO: Future — add estimatedReadyTime: Date
/// TODO: Future — add confirmationEmailSent: Bool
/// TODO: Future — use confirmationId as the reference shown to customer and baker
struct OrderConfirmation: Hashable, Decodable {
    let confirmationId: String
    let pickupDate: String
    let pickupWindow: String
    let total: Double

    var formattedPickupDate: String { pickupDate.strippingDateTimestamp }
    var formattedPickupWindow: String { pickupWindow.strippingTimeSeconds }
}
