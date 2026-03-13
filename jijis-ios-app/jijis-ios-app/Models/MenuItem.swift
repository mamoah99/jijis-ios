//
//  MenuItem.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

struct MenuItem: Identifiable, Decodable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageNames: [String]    // ordered list; first is the hero image
    let ingredients: [String]
    let allergens: [String]

    // TODO: Future — add soldOut: Bool
    // TODO: Future — add availableQuantity: Int
    // TODO: Future — replace imageNames with remote URLs for real photo loading
    // TODO: Future — add customerPhotos: [URL]
}

// MARK: - Decodable

extension MenuItem {
    /// The sheet stores `id` as a plain string (e.g. "1" or a UUID).
    /// We try to parse it as UUID; if that fails we generate one so the
    /// app never crashes on a malformed id value.
    private enum CodingKeys: String, CodingKey {
        case id, name, description, price, imageNames, ingredients, allergens
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try c.decode(String.self, forKey: .id)
        self.id          = UUID(uuidString: idString) ?? UUID()
        self.name        = try c.decode(String.self,   forKey: .name)
        self.description = try c.decode(String.self,   forKey: .description)
        self.price       = try c.decode(Double.self,   forKey: .price)
        self.imageNames  = try c.decode([String].self, forKey: .imageNames)
        self.ingredients = try c.decode([String].self, forKey: .ingredients)
        self.allergens   = try c.decode([String].self, forKey: .allergens)
    }
}
