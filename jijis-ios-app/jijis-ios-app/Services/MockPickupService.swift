//
//  MockPickupService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Local mock implementation of PickupServiceProtocol.
/// Returns hardcoded available pickup slots. Replace with a real API call when ready.
///
/// TODO: Future — replace with APIPickupService that fetches live windows from backend
/// TODO: Future — include capacity and sold-out status per slot
struct MockPickupService: PickupServiceProtocol {
    func fetchAvailableSlots() async throws -> [PickupSlot] {
        // Simulate a brief network delay
        try await Task.sleep(nanoseconds: 300_000_000)

        let dates = ["Friday, March 15", "Saturday, March 16", "Sunday, March 17"]
        let windows = ["10:00 AM – 12:00 PM", "12:00 PM – 2:00 PM", "2:00 PM – 4:00 PM"]

        // Return a slot for every date × time window combination
        return dates.flatMap { date in
            windows.map { window in
                PickupSlot(id: UUID().uuidString, date: date, timeWindow: window)
            }
        }
    }
}
