//
//  PickupService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Defines how the app fetches available pickup slots.
///
/// TODO: Future — implement with real API that returns live available windows
/// TODO: Future — add func markSlotSoldOut(id: UUID) for admin use
/// TODO: Future — add capacity-based availability per slot
protocol PickupServiceProtocol {
    func fetchAvailableSlots() async throws -> [PickupSlot]
}
