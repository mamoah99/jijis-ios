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

        print("[OrderHistoryService] → GET \(url)")

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            print("[OrderHistoryService] ✗ Network error: \(error)")
            throw ServiceError.networkFailed(underlying: error)
        }

        if let http = response as? HTTPURLResponse {
            print("[OrderHistoryService] ← status \(http.statusCode)")
            if http.statusCode != 200 {
                print("[OrderHistoryService] ✗ Non-200 body: \(String(data: data, encoding: .utf8) ?? "<binary>")")
                throw ServiceError.invalidResponse(statusCode: http.statusCode)
            }
        }

        print("[OrderHistoryService] Raw body: \(String(data: data, encoding: .utf8) ?? "<binary>")")

        do {
            return try JSONDecoder().decode([CustomerOrder].self, from: data)
        } catch {
            print("[OrderHistoryService] ✗ Decoding error: \(error)")
            throw ServiceError.decodingFailed(underlying: error)
        }
    }
}
