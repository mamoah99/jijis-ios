//
//  CustomerInfo.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Snapshot of customer contact info attached to an order.
/// Built from UserProfileViewModel at checkout time.
///
/// TODO: Future — add userId once authentication is introduced
/// TODO: Future — add deliveryAddress once delivery is supported
struct CustomerInfo: Encodable {
    let name: String
    let email: String
    let phone: String
}
