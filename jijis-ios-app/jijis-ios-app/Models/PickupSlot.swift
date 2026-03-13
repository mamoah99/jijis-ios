//
//  PickupSlot.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

// MARK: - Time formatting helper

extension String {
    /// Strips trailing seconds from Sheets-formatted times, e.g. "10:00:00 AM" → "10:00 AM".
    var strippingTimeSeconds: String {
        replacingOccurrences(
            of: #"(\d{1,2}:\d{2}):\d{2}"#,
            with: "$1",
            options: .regularExpression
        )
    }

    /// Strips the timestamp portion from date strings.
    /// Handles ISO 8601 ("2026-03-15T03:28:27.568Z" → "2026-03-15") and
    /// Sheets-style suffixes ("Friday, March 15, 2026 0:00:00" → "Friday, March 15, 2026").
    var strippingDateTimestamp: String {
        // ISO 8601: split on T and take the date portion
        if let tRange = range(of: "T") {
            return String(self[startIndex..<tRange.lowerBound])
        }
        // Sheets-style: strip trailing " H:MM:SS"
        return replacingOccurrences(
            of: #"\s+\d{1,2}:\d{2}(:\d{2})?(\s*(AM|PM))?\s*$"#,
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
    }
}

/// A single pickup window returned by PickupService.
/// id is a String so Codable is fully synthesised without a custom decoder.
/// isSoldOut defaults to false so existing JSON without the key decodes safely.
///
/// TODO: Future — replace date/timeWindow strings with typed Date values
/// TODO: Future — add capacity: Int for count-based availability (e.g. "3 spots left")
/// TODO: Future — fetch live from backend (Supabase or API)
struct PickupSlot: Identifiable, Hashable, Codable {
    let id: String
    let date: String
    let timeWindow: String
    var isSoldOut: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, date, timeWindow, isSoldOut
    }

    init(id: String, date: String, timeWindow: String, isSoldOut: Bool = false) {
        self.id = id
        self.date = date
        self.timeWindow = timeWindow
        self.isSoldOut = isSoldOut
    }

    /// `date` as received from the backend, with any trailing timestamp stripped.
    var formattedDate: String { date.strippingDateTimestamp }
    var formattedTimeWindow: String { timeWindow.strippingTimeSeconds }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        date = try c.decode(String.self, forKey: .date)
        timeWindow = try c.decode(String.self, forKey: .timeWindow)
        // Backend may send "TRUE"/"FALSE" string or a Bool — handle both.
        if let boolVal = try? c.decode(Bool.self, forKey: .isSoldOut) {
            isSoldOut = boolVal
        } else if let strVal = try? c.decode(String.self, forKey: .isSoldOut) {
            isSoldOut = strVal.trimmingCharacters(in: .whitespaces).uppercased() == "TRUE"
        } else {
            isSoldOut = false
        }
    }
}
