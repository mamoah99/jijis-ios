//
//  PickupSelectionView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

struct PickupSelectionView: View {
    let dismissSheet: () -> Void

    @StateObject private var viewModel = PickupViewModel()
    @EnvironmentObject var services: ServiceContainer

    @State private var selectedDate: String? = nil
    @State private var selectedSlot: PickupSlot? = nil

    private var selectionIsComplete: Bool {
        selectedDate != nil && selectedSlot != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                if viewModel.isLoading {
                    ProgressView("Loading available times…")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)

                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.secondary)
                        .padding()

                } else {

                    // MARK: - Date selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pickup Date")
                            .font(.headline)

                        ForEach(viewModel.availableDates, id: \.self) { date in
                            SelectionRow(label: date, isSelected: selectedDate == date) {
                                selectedDate = date
                                selectedSlot = nil  // reset window when date changes
                            }
                        }
                        // TODO: Future — show sold-out label on full pickup days
                    }

                    Divider()

                    // MARK: - Time window selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pickup Window")
                            .font(.headline)

                        if let date = selectedDate {
                            ForEach(viewModel.windows(for: date)) { slot in
                                SelectionRow(label: slot.timeWindow, isSelected: selectedSlot == slot) {
                                    selectedSlot = slot
                                }
                            }
                        } else {
                            Text("Select a date first.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        // TODO: Future — show remaining capacity per window
                        // TODO: Future — disable sold-out windows
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Choose Pickup")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadSlots(using: services.pickup)
        }
        .safeAreaInset(edge: .bottom) {
            if let slot = selectedSlot {
                NavigationLink(destination: OrderReviewView(slot: slot, dismissSheet: dismissSheet)) {
                    Text("Review Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectionIsComplete ? Color.brown : Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
                .disabled(!selectionIsComplete)
                .background(.ultraThinMaterial)
            } else {
                Text("Select a date and time above to continue.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
            }
        }
    }
}

// MARK: - Reusable selection row

private struct SelectionRow: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.brown : .secondary)
            }
            .padding()
            .background(isSelected ? Color.brown.opacity(0.08) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    NavigationStack {
        PickupSelectionView(dismissSheet: {})
            .environmentObject(CartViewModel())
            .environmentObject(ServiceContainer.mock)
    }
}
