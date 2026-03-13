//
//  GoogleSheetsOrderService.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

/// Submits orders to the Google Sheets / Apps Script backend via HTTP POST.
///
/// The confirmation ID is generated on the Swift side before the request is sent.
/// It is embedded in the request body so the Apps Script writes the same ID to
/// the sheet. On HTTP 200 we return a locally constructed OrderConfirmation
/// rather than parsing the response body — this avoids issues caused by
/// Google's POST-redirect behaviour where the redirected response body may
/// not be the clean JSON we expect.
///
/// TODO: Future — replace with Supabase or dedicated API when backend matures
/// TODO: Future — add Stripe PaymentIntent before calling this service
/// TODO: Future — backend should trigger confirmation email on success
struct GoogleSheetsOrderService: OrderServiceProtocol {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func submitOrder(_ request: OrderRequest) async throws -> OrderConfirmation {
        // Generate the ID here so Swift and the sheet always agree on it.
        let confirmationId = "JIJI-\(Int.random(in: 1000...9999))"

        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Wrap the request with the client-generated ID before encoding.
        let payload = OrderPayload(confirmationId: confirmationId, request: request)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(payload)
        } catch {
            throw ServiceError.decodingFailed(underlying: error)
        }

        print("[OrderService] → POST \(baseURL)")
        if let body = urlRequest.httpBody {
            print("[OrderService] Request body: \(String(data: body, encoding: .utf8) ?? "<binary>")")
        }

        let data: Data
        let response: URLResponse

        do {
            // Google Apps Script returns a 302 to an echo URL that serves the response.
            // URLSession follows that redirect as a GET by default — exactly what we want.
            (data, response) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            print("[OrderService] ✗ Network error: \(error)")
            throw ServiceError.networkFailed(underlying: error)
        }

        if let http = response as? HTTPURLResponse {
            print("[OrderService] ← status \(http.statusCode)")
            if http.statusCode != 200 {
                print("[OrderService] ✗ Non-200 body: \(String(data: data, encoding: .utf8) ?? "<binary>")")
                throw ServiceError.invalidResponse(statusCode: http.statusCode)
            }
        }

        print("[OrderService] Raw body: \(String(data: data, encoding: .utf8) ?? "<binary>")")

        // Construct the confirmation locally — no response body parsing needed.
        return OrderConfirmation(
            confirmationId: confirmationId,
            pickupDate: request.pickupSlot.date,
            pickupWindow: request.pickupSlot.timeWindow,
            total: request.total
        )
    }
}

// MARK: - Internal encoding type

/// OrderRequest plus the client-generated confirmationId sent to the script.
/// Kept private — nothing outside this file needs to know about it.
private struct OrderPayload: Encodable {
    let confirmationId: String
    let customer: CustomerInfo
    let items: [OrderItem]
    let pickupSlot: PickupSlot
    let subtotal: Double
    let tipAmount: Double
    let total: Double
    let paymentMethod: String

    init(confirmationId: String, request: OrderRequest) {
        self.confirmationId = confirmationId
        self.customer       = request.customer
        self.items          = request.items
        self.pickupSlot     = request.pickupSlot
        self.subtotal       = request.subtotal
        self.tipAmount      = request.tipAmount
        self.total          = request.total
        self.paymentMethod  = request.paymentMethod
    }
}

