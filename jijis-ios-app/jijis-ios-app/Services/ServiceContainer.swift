//
//  ServiceContainer.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation
import Combine

/// The live Apps Script web app URL.
/// To switch backends, update this constant and swap the service implementations below.
///
/// TODO: Future — move to a config file or environment variable
private let googleSheetsBaseURL = URL(
    string: "https://script.google.com/macros/s/AKfycbxW-2BhXgPRjt3J8NFo2a5f5ZPvaQOmpVSAzpXRykg4g1idNiCVLvkF7GgN4TMSLfYbdA/exec"
)!

/// Holds all service dependencies for the app.
/// Injected at the app root — swap implementations here to change backends.
///
/// TODO: Future — add AuthService once user accounts are introduced
/// TODO: Future — add NotificationService for push notification scheduling
/// TODO: Future — add InventoryService for sold-out / availability checks
class ServiceContainer: ObservableObject {
    let menu: MenuServiceProtocol
    let pickup: PickupServiceProtocol
    let order: OrderServiceProtocol
    let orderHistory: OrderHistoryServiceProtocol

    /// Live initialiser — uses the Google Sheets backend by default.
    init(
        menu: MenuServiceProtocol                 = GoogleSheetsMenuService(baseURL: googleSheetsBaseURL),
        pickup: PickupServiceProtocol             = GoogleSheetsPickupService(baseURL: googleSheetsBaseURL),
        order: OrderServiceProtocol               = GoogleSheetsOrderService(baseURL: googleSheetsBaseURL),
        orderHistory: OrderHistoryServiceProtocol = GoogleSheetsOrderHistoryService(baseURL: googleSheetsBaseURL)
    ) {
        self.menu         = menu
        self.pickup       = pickup
        self.order        = order
        self.orderHistory = orderHistory
    }

    /// Mock container for use in Xcode Previews — instant, no network calls.
    static var mock: ServiceContainer {
        ServiceContainer(
            menu:         MockMenuService(),
            pickup:       MockPickupService(),
            order:        MockOrderService(),
            orderHistory: MockOrderHistoryService()
        )
    }
}
