//
//  CurrentOrdersView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

struct CurrentOrdersView: View {
    @EnvironmentObject var userProfile: UserProfileViewModel
    @EnvironmentObject var services: ServiceContainer
    @StateObject private var viewModel = CurrentOrdersViewModel()

    var body: some View {
        Group {
            if userProfile.email.trimmingCharacters(in: .whitespaces).isEmpty {
                // No email saved — guide the user
                ContentUnavailableView(
                    "No Email on File",
                    systemImage: "envelope",
                    description: Text("Place an order first and enter your email at checkout. Your orders will appear here automatically.")
                )

            } else if viewModel.isLoading {
                ProgressView("Loading your orders…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text(error)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button("Try Again") {
                        Task {
                            await viewModel.loadOrders(
                                for: userProfile.email,
                                using: services.orderHistory
                            )
                        }
                    }
                    .buttonStyle(.bordered)
                }

            } else if viewModel.orders.isEmpty {
                ContentUnavailableView(
                    "No Orders Yet",
                    systemImage: "bag",
                    description: Text("Your upcoming and active orders will appear here once you've placed one.")
                )

            } else {
                List(viewModel.orders) { order in
                    OrderCard(order: order)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    // TODO: Future — tap to open order detail screen
                    // TODO: Future — show cancellation option if within allowed window
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Current Orders")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadOrders(
                for: userProfile.email,
                using: services.orderHistory
            )
        }

        // TODO: Future — add pull-to-refresh
        // TODO: Future — filter into "upcoming" vs "completed" sections
        // TODO: Future — trigger push notification opt-in from here
    }
}

// MARK: - Order card

private struct OrderCard: View {
    let order: CustomerOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(order.confirmationId)
                    .font(.headline)
                Spacer()
                Text("Confirmed")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.brown)
                    .clipShape(Capsule())
            }

            Text(order.itemSummary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            HStack {
                Label(order.pickupDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Label(order.pickupWindow, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(String(format: "$%.2f", order.total))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brown)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)

        // TODO: Future — show different status colors (green = ready, grey = completed)
        // TODO: Future — add authenticated account linking for richer order history
    }
}

#Preview {
    NavigationStack {
        CurrentOrdersView()
            .environmentObject(UserProfileViewModel())
            .environmentObject(ServiceContainer.mock)
    }
}
