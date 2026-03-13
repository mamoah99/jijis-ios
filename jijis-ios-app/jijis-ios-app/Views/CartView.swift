//
//  CartView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

struct CartView: View {
    let goToRoot: () -> Void

    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var services: ServiceContainer
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if cartViewModel.items.isEmpty {
                    ContentUnavailableView(
                        "Your cart is empty",
                        systemImage: "bag",
                        description: Text("Add items from this week's menu to get started.")
                    )
                    .background(Color.brandWarmWhite)
                } else {
                    List {
                        ForEach(cartViewModel.items) { cartItem in
                            CartItemRow(cartItem: cartItem)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.brandWarmWhite)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        cartViewModel.remove(cartItem)
                                    } label: {
                                        Label("Remove", systemImage: "trash")
                                    }
                                }
                        }

                        Section {
                            HStack {
                                Text("Subtotal")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "$%.2f", cartViewModel.subtotal))
                                    .font(.headline)
                                    .foregroundStyle(Color.brandOrange)
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color.brandWarmWhite)
                        }

                        // TODO: Future — show promo code entry field here
                        // TODO: Future — show estimated tax and total
                        // TODO: Future — show loyalty rewards balance here
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.brandWarmWhite)
                }
            }
            .navigationTitle("Your Cart")
            .navigationBarTitleDisplayMode(.large)
            .safeAreaInset(edge: .bottom) {
                if !cartViewModel.items.isEmpty {
                    // dismissSheet dismisses the cart sheet AND returns to home.
                    NavigationLink(
                        destination: PickupSelectionView(dismissSheet: { dismiss(); goToRoot() })
                            .environmentObject(services)
                    ) {
                        Text("Proceed to Checkout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brandHotPink)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }
                    .background(.ultraThinMaterial)

                    // TODO: Future — add order notes field before checkout
                    // TODO: Future — add promo code entry before checkout
                }
            }
        }
    }
}

// MARK: - Cart Item Row

private struct CartItemRow: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    let cartItem: CartItem

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.menuItem.name)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(String(format: "$%.2f each", cartItem.menuItem.price))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 12) {
                Button {
                    cartViewModel.decreaseQuantity(for: cartItem)
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.title3)
                        .foregroundStyle(Color.brandHotPink)
                }

                Text("\(cartItem.quantity)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(minWidth: 20, alignment: .center)

                Button {
                    cartViewModel.increaseQuantity(for: cartItem)
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundStyle(Color.brandHotPink)
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CartView(goToRoot: {})
        .environmentObject(CartViewModel())
        .environmentObject(ServiceContainer.mock)
}
