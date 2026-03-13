//
//  GoogleSheetsPickupService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Fetches all pickup slots from the Google Sheets / Apps Script backend,
/// including sold-out ones so the UI can display them as non-selectable.
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
            return try JSONDecoder().decode([PickupSlot].self, from: data)
        } catch {
            throw ServiceError.decodingFailed(underlying: error)
        }
    }
}
