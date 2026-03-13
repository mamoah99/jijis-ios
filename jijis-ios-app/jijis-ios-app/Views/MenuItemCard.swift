//
//  MenuItemCard.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

struct MenuItemCard: View {
    let item: MenuItem

    var body: some View {
        HStack(spacing: 14) {

            // MARK: - Thumbnail
            // Loads the first image from the asset catalog if available; warm placeholder otherwise.
            // TODO: Future — use AsyncImage for remote URLs
            Group {
                if let first = item.imageNames.first, let uiImage = UIImage(named: first) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                } else {
                    Color.brandBlush.opacity(0.6)
                        .overlay {
                            Image(systemName: "birthday.cake")
                                .font(.title3)
                                .foregroundStyle(Color.brandHotPink.opacity(0.7))
                        }
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // MARK: - Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(Color.brandDarkBrown)
                    .lineLimit(2)

                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brandOrange)
            }

            Spacer(minLength: 0)

            // TODO: Future — show allergen info badges here
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    MenuItemCard(item: MenuItem(
        id: UUID(),
        name: "Classic Salt Bread",
        description: "Pillowy soft Japanese-style salt bread with a golden, buttery crust.",
        price: 4.50,
        imageNames: ["classic_salt_bread_1"],
        ingredients: ["Bread flour", "Butter", "Milk", "Salt", "Yeast", "Sugar"],
        allergens: ["Gluten", "Dairy"]
    ))
    .padding()
    .background(Color.brandWarmWhite)
}
