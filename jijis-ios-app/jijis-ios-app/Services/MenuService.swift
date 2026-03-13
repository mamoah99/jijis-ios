//
//  MenuService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Defines how the app fetches menu items.
/// Swap MockMenuService for a real implementation when the backend is ready.
///
/// TODO: Future — implement with URLSession or Supabase client
/// TODO: Future — add func fetchItem(id: UUID) for single-item detail fetching
/// TODO: Future — add sold-out / availability updates via websocket or polling
protocol MenuServiceProtocol {
    func fetchMenu() async throws -> [MenuItem]
}
