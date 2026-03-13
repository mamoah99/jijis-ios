//
//  jijis_ios_appApp.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

@main
struct JijisPatisserieApp: App {
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var userProfile = UserProfileViewModel()

    // Swap MockXxxService for real implementations here when the backend is ready.
    // e.g. ServiceContainer(menu: SupabaseMenuService(), order: APIOrderService())
    @StateObject private var services = ServiceContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cartViewModel)
                .environmentObject(userProfile)
                .environmentObject(services)
        }
    }
}
