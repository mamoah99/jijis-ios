//
//  MenuView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

struct MenuView: View {
    let goToRoot: () -> Void

    @StateObject private var viewModel = MenuViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var services: ServiceContainer
    @State private var showingCart = false

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading menu…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.brandWarmWhite)
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView(
                    "Menu unavailable",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .background(Color.brandWarmWhite)
            } else {
                List(viewModel.menuItems) { item in
                    NavigationLink(destination: MenuItemDetailView(item: item)) {
                        MenuItemCard(item: item)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.brandWarmWhite)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.brandWarmWhite)
            }
        }
        .navigationTitle("This Week's Menu")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingCart = true
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bag").font(.body)
                        if cartViewModel.totalItemCount > 0 {
                            Text("\(cartViewModel.totalItemCount)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(3)
                                .background(Color.brandHotPink)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingCart) {
            CartView(goToRoot: goToRoot)
                .environmentObject(cartViewModel)
                .environmentObject(services)
        }
        .task {
            await viewModel.loadMenu(using: services.menu)
        }
        // TODO: Future — add pull-to-refresh calling viewModel.loadMenu()
        // TODO: Future — show sold-out overlay per item from inventory service
    }
}

#Preview {
    NavigationStack {
        MenuView(goToRoot: {})
            .environmentObject(CartViewModel())
            .environmentObject(ServiceContainer.mock)
    }
}
