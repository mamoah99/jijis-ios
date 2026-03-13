//
//  PickupViewModel.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation
import Combine

@MainActor
class PickupViewModel: ObservableObject {
    @Published var slots: [PickupSlot] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    /// All unique dates across all slots (including sold-out).
    var availableDates: [String] {
        var seen = Set<String>()
        return slots.compactMap { seen.insert($0.date).inserted ? $0.date : nil }
    }

    /// All windows for a date, including sold-out ones.
    func windows(for date: String) -> [PickupSlot] {
        slots.filter { $0.date == date }
    }

    /// True when every slot across all dates is sold out.
    var allSlotsSoldOut: Bool {
        !slots.isEmpty && slots.allSatisfy(\.isSoldOut)
    }

    func loadSlots(using service: PickupServiceProtocol) async {
        isLoading = true
        errorMessage = nil
        do {
            // fetchAvailableSlots now returns all slots, including sold-out ones.
            slots = try await service.fetchAvailableSlots()
        } catch {
            errorMessage = "Couldn't load pickup times. Please try again."
        }
        isLoading = false
    }
}
