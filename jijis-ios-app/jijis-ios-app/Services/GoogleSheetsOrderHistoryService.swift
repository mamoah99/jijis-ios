//
//  GoogleSheetsOrderHistoryService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Fetches a customer's orders from the Google Sheets backend using email as the lookup key.
/// Requires the Apps Script to support: GET BASE_URL?type=orders&email=...
///
/// TODO: Future — replace email lookup with authenticated user ID
/// TODO: Future — replace with Supabase or dedicated API when backend matures
struct GoogleSheetsOrderHistoryService: OrderHistoryServiceProtocol {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func fetchOrders(for email: String) async throws -> [CustomerOrder] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "type", value: "orders"),
            URLQueryItem(name: "email", value: email)
        ]

        guard let url = components?.url else {
            throw ServiceError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw ServiceError.networkFailed(underlying: error)
        }

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw ServiceError.invalidResponse(statusCode: http.statusCode)
        }

        do {
            return try JSONDecoder().decode([CustomerOrder].self, from: data)
        } catch {
            throw ServiceError.decodingFailed(underlying: error)
        }
    }
}
