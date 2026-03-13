//
//  MockMenuService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Local mock implementation of MenuServiceProtocol.
/// Returns hardcoded sample data. Replace with a real network call when ready.
///
/// TODO: Future — replace with SupabaseMenuService or APIMenuService
struct MockMenuService: MenuServiceProtocol {
    func fetchMenu() async throws -> [MenuItem] {
        // Simulate a brief network delay
        try await Task.sleep(nanoseconds: 500_000_000)

        return [
            MenuItem(
                id: UUID(),
                name: "Classic Salt Bread",
                description: "Pillowy soft Japanese-style salt bread with a golden, buttery crust. Baked fresh every drop day.",
                price: 4.50,
                imageNames: ["classic_salt_bread_1", "classic_salt_bread_2", "classic_salt_bread_3"],
                ingredients: ["Bread flour", "Butter", "Milk", "Salt", "Yeast", "Sugar"],
                allergens: ["Gluten", "Dairy"]
            ),
            MenuItem(
                id: UUID(),
                name: "Truffle Egg Salad Salt Bread",
                description: "Our signature salt bread filled with creamy truffle-infused egg salad. Rich, savory, and deeply satisfying.",
                price: 6.50,
                imageNames: ["truffle_egg_salad_1", "truffle_egg_salad_2", "truffle_egg_salad_3"],
                ingredients: ["Salt bread", "Eggs", "Kewpie mayo", "Truffle oil", "Chives", "Salt", "Pepper"],
                allergens: ["Gluten", "Dairy", "Eggs"]
            ),
            MenuItem(
                id: UUID(),
                name: "S'mores Salt Bread",
                description: "Salt bread filled with chocolate ganache, toasted marshmallow, and graham crumble. A campfire classic, reimagined.",
                price: 5.50,
                imageNames: ["smores_1", "smores_2", "smores_3"],
                ingredients: ["Salt bread", "Dark chocolate", "Heavy cream", "Marshmallow", "Graham crackers", "Butter"],
                allergens: ["Gluten", "Dairy", "Soy"]
            )
        ]
    }
}
