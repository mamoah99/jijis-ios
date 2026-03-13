//
//  PickupSlot.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation

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
