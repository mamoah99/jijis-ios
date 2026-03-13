//
//  ServiceError.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Errors that can be thrown by any service implementation.
enum ServiceError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(underlying: Error)
    case networkFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse(let code):
            return "Unexpected server response (status \(code))."
        case .decodingFailed(let underlying):
            return "Decoding failed: \(underlying.localizedDescription)"
        case .networkFailed(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        }
    }
}
