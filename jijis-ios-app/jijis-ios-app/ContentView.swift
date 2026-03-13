//
//  ContentView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

// Destinations reachable from the home screen.
private enum HomeDestination: Hashable {
    case menu
    case orders
}

struct ContentView: View {
    // NavigationPath lets us reset to root cleanly after order confirmation.
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                Spacer()

                Text("Jiji's Patisserie")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Salt Bread Drops")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Spacer()

                Button { path.append(HomeDestination.menu) } label: {
                    Text("View This Week's Menu")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button { path.append(HomeDestination.orders) } label: {
                    Text("View Current Orders")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // TODO: Future — add "My Cart" shortcut button here
                // TODO: Future — add loyalty rewards / account shortcut here

                Spacer()
            }
            .padding(.horizontal)
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .menu:
                    // goToRoot resets the path, returning the user to this screen.
                    MenuView(goToRoot: { path = NavigationPath() })
                case .orders:
                    CurrentOrdersView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CartViewModel())
        .environmentObject(UserProfileViewModel())
        .environmentObject(ServiceContainer.mock)
}
