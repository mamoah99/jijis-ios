//
//  BrandTheme.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

// MARK: - Brand palette
// Centralised colour constants — update values here to retheme the entire app.
//
// Usage guide:
//   brandWarmWhite  — main screen backgrounds
//   brandHotPink    — primary CTAs and badges only
//   brandBlush      — secondary cards, placeholders, soft accents
//   brandOrange     — prices and warm highlights
//   brandButter     — decorative accents, subtle highlights
//   brandDarkBrown  — primary text, headings

extension Color {
    static let brandDarkBrown = Color(red: 0.169, green: 0.125, blue: 0.051) // #2b200d
    static let brandButter    = Color(red: 1.0,   green: 0.949, blue: 0.510) // #fff282
    static let brandBlush     = Color(red: 1.0,   green: 0.773, blue: 0.847) // #ffc5d8
    static let brandOrange    = Color(red: 0.933, green: 0.490, blue: 0.098) // #ee7d19
    static let brandWarmWhite = Color(red: 1.0,   green: 1.0,   blue: 0.988) // #fffffc
    static let brandHotPink   = Color(red: 0.976, green: 0.118, blue: 0.467) // #f91e77
}
