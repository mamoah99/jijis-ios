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
            ZStack {
                Color.brandWarmWhite.ignoresSafeArea()

                // Decorative soft background accents
                Circle()
                    .fill(Color.brandBlush.opacity(0.6))
                    .frame(width: 300)
                    .offset(x: 130, y: -340)
                Circle()
                    .fill(Color.brandBlush.opacity(0.35))
                    .frame(width: 220)
                    .offset(x: -120, y: 300)

                VStack(spacing: 0) {
                    Spacer()

                    // Brand header
                    VStack(spacing: 12) {
                        if let logoImage = UIImage(named: "logo") {
                            Image(uiImage: logoImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                        } else {
                            VStack(spacing: 6) {
                                Text("Jiji's")
                                    .font(.system(size: 56, weight: .bold, design: .serif))
                                    .foregroundStyle(Color.brandHotPink)

                                Text("Patisserie")
                                    .font(.system(size: 40, weight: .light, design: .serif))
                                    .foregroundStyle(Color.brandDarkBrown)
                            }
                        }

                        Text("· Salt Bread Drops ·")
                            .font(.caption)
                            .foregroundStyle(Color.brandDarkBrown.opacity(0.5))
                            .tracking(3)
                    }

                    Spacer()

                    // Action buttons
                    VStack(spacing: 12) {
                        Button {
                            path.append(HomeDestination.menu)
                        } label: {
                            Text("View This Week's Menu")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brandHotPink)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }

                        Button {
                            path.append(HomeDestination.orders)
                        } label: {
                            Text("View Current Orders")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brandBlush.opacity(0.35))
                                .foregroundStyle(Color.brandDarkBrown)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.brandHotPink.opacity(0.3), lineWidth: 1.5)
                                }
                        }

                        // TODO: Future — add "My Cart" shortcut button here
                        // TODO: Future — add loyalty rewards / account shortcut here
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 52)
                }
            }
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
