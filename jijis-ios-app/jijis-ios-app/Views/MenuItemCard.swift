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
        HStack(spacing: 12) {

            // MARK: - Thumbnail
            // TODO: Future — replace with Image(item.imageNames[0]) once assets are added
            // TODO: Future — use AsyncImage for remote URLs
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
                .frame(width: 72, height: 72)
                .overlay {
                    Image(systemName: "fork.knife")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

            // MARK: - Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)

                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brown)
            }

            Spacer(minLength: 0)

            // TODO: Future — show allergen info badges here
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
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
}
