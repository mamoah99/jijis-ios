//
//  MenuItemDetailView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

struct MenuItemDetailView: View {
    let item: MenuItem
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedImageIndex = 0
    @State private var showingFullScreen = false
    @State private var quantity = 1
    @State private var addedToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Image carousel
                // TODO: Future — replace placeholders with Image(imageName) once assets are added
                // TODO: Future — use AsyncImage for remote photo URLs
                // TODO: Future — add customer-submitted photos as extra pages
                TabView(selection: $selectedImageIndex) {
                    ForEach(item.imageNames.indices, id: \.self) { index in
                        ImagePlaceholder()
                            .tag(index)
                            .onTapGesture { showingFullScreen = true }
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                .fullScreenCover(isPresented: $showingFullScreen) {
                    FullScreenImageViewer(
                        count: item.imageNames.count,
                        startIndex: selectedImageIndex,
                        isPresented: $showingFullScreen
                    )
                }

                // MARK: - Name & Price
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(String(format: "$%.2f", item.price))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.brown)
                }
                .padding(.horizontal)

                // MARK: - Description
                Text(item.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                Divider().padding(.horizontal)

                // MARK: - Quantity selector
                HStack {
                    Text("Quantity")
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 16) {
                        Button {
                            if quantity > 1 { quantity -= 1 }
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.title2)
                                .foregroundStyle(quantity > 1 ? Color.brown : Color.gray)
                        }
                        .disabled(quantity <= 1)

                        Text("\(quantity)")
                            .font(.headline)
                            .frame(minWidth: 28, alignment: .center)

                        Button {
                            quantity += 1
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                                .foregroundStyle(Color.brown)
                        }
                    }
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                // MARK: - Ingredients
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.headline)
                    ForEach(item.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    // TODO: Future — add customization options (e.g. extra butter, no salt)
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                // MARK: - Allergens
                VStack(alignment: .leading, spacing: 8) {
                    Text("Allergens")
                        .font(.headline)
                    Text(item.allergens.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    // TODO: Future — show allergen badges with icons
                }
                .padding(.horizontal)

                Spacer(minLength: 100)
            }
            .padding(.top)
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {

            // MARK: - Add to Cart button
            // TODO: Future — add customization options before adding to cart
            Button {
                cartViewModel.add(item, quantity: quantity)
                addedToCart = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    dismiss()
                }
            } label: {
                Text(addedToCart ? "Added to Cart!" : "Add \(quantity > 1 ? "\(quantity) " : "")to Cart — \(String(format: "$%.2f", item.price * Double(quantity)))")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(addedToCart ? Color.green : Color.brown)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .animation(.easeInOut(duration: 0.2), value: addedToCart)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Image placeholder (swap for real Image() once assets are ready)

private struct ImagePlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color(.systemGray5))
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
            }
    }
}

// MARK: - Full-screen image viewer

private struct FullScreenImageViewer: View {
    let count: Int
    let startIndex: Int
    @Binding var isPresented: Bool
    @State private var currentIndex: Int

    init(count: Int, startIndex: Int, isPresented: Binding<Bool>) {
        self.count = count
        self.startIndex = startIndex
        self._isPresented = isPresented
        self._currentIndex = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(0..<count, id: \.self) { index in
                    // TODO: Future — display real image with Image(imageNames[index])
                    Color(.systemGray4)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: 64))
                                .foregroundStyle(.secondary)
                        }
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .ignoresSafeArea()

            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MenuItemDetailView(item: MenuItem(
            id: UUID(),
            name: "Classic Salt Bread",
            description: "Pillowy soft Japanese-style salt bread with a golden, buttery crust. Baked fresh every drop day.",
            price: 4.50,
            imageNames: ["classic_salt_bread_1", "classic_salt_bread_2"],
            ingredients: ["Bread flour", "Butter", "Milk", "Salt", "Yeast", "Sugar"],
            allergens: ["Gluten", "Dairy"]
        ))
        .environmentObject(CartViewModel())
    }
}
