//
//  CartItem.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

struct CartItem: Identifiable {
    let id: UUID
    let menuItem: MenuItem
    var quantity: Int

    // TODO: Future — add orderNotes: String for special requests
    // TODO: Future — add customizations: [String] (e.g. "extra butter")
}
