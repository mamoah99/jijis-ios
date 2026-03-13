//
//  GoogleSheetsMenuService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Fetches menu items from the Google Sheets / Apps Script backend.
/// Conforms to MenuServiceProtocol — swap back to MockMenuService for previews.
///
/// TODO: Future — replace with Supabase or dedicated API when backend matures
struct GoogleSheetsMenuService: MenuServiceProtocol {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func fetchMenu() async throws -> [MenuItem] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "type", value: "menu")]

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
            return try JSONDecoder().decode([MenuItem].self, from: data)
        } catch {
            throw ServiceError.decodingFailed(underlying: error)
        }
    }
}
