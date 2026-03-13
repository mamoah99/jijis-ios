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

    /// Groups slots by date for display in the picker.
    var availableDates: [String] {
        var seen = Set<String>()
        return slots.compactMap { seen.insert($0.date).inserted ? $0.date : nil }
    }

    func windows(for date: String) -> [PickupSlot] {
        slots.filter { $0.date == date }
    }

    func loadSlots(using service: PickupServiceProtocol) async {
        isLoading = true
        errorMessage = nil
        do {
            slots = try await service.fetchAvailableSlots()
        } catch {
            errorMessage = "Couldn't load pickup times. Please try again."
        }
        isLoading = false
    }
}
