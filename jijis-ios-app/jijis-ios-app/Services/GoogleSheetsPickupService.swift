//
//  GoogleSheetsPickupService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Fetches available pickup slots from the Google Sheets / Apps Script backend.
/// The backend already filters out sold-out slots before responding.
///
/// TODO: Future — replace with Supabase or dedicated API when backend matures
/// TODO: Future — add real-time sold-out updates via polling or websockets
struct GoogleSheetsPickupService: PickupServiceProtocol {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func fetchAvailableSlots() async throws -> [PickupSlot] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "type", value: "pickupSlots")]

        guard let url = components?.url else {
            throw ServiceError.invalidURL
        }

        print("[PickupService] → GET \(url)")

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            print("[PickupService] ✗ Network error: \(error)")
            throw ServiceError.networkFailed(underlying: error)
        }

        if let http = response as? HTTPURLResponse {
            print("[PickupService] ← status \(http.statusCode)")
            if http.statusCode != 200 {
                print("[PickupService] ✗ Non-200 body: \(String(data: data, encoding: .utf8) ?? "<binary>")")
                throw ServiceError.invalidResponse(statusCode: http.statusCode)
            }
        }

        print("[PickupService] Raw body: \(String(data: data, encoding: .utf8) ?? "<binary>")")

        do {
            return try JSONDecoder().decode([PickupSlot].self, from: data)
        } catch {
            print("[PickupService] ✗ Decoding error: \(error)")
            throw ServiceError.decodingFailed(underlying: error)
        }
    }
}
