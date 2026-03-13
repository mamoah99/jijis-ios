//
//  PickupSlot.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// A single available pickup window returned by PickupService.
/// id is a String so Codable is fully synthesised without a custom decoder.
///
/// TODO: Future — replace date/timeWindow strings with typed Date values
/// TODO: Future — add capacity: Int and isSoldOut: Bool
/// TODO: Future — fetch live from backend (Supabase or API)
struct PickupSlot: Identifiable, Hashable, Codable {
    let id: String
    let date: String
    let timeWindow: String
}
