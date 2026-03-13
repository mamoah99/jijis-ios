//
//  MenuViewModel.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation
import Combine

@MainActor
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func loadMenu(using service: MenuServiceProtocol) async {
        isLoading = true
        errorMessage = nil
        do {
            menuItems = try await service.fetchMenu()
        } catch {
            errorMessage = "Couldn't load the menu. Please try again."
        }
        isLoading = false
    }
}
