//
//  UserProfileViewModel.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import Foundation
import Combine

// Persists contact info to UserDefaults so it pre-fills on future orders.
// TODO: Future — sync profile to backend / user account
// TODO: Future — add delivery address once delivery is supported
// TODO: Future — add push notification opt-in preference here
@MainActor
class UserProfileViewModel: ObservableObject {

    @Published var name: String {
        didSet { UserDefaults.standard.set(name, forKey: "profile_name") }
    }
    @Published var email: String {
        didSet { UserDefaults.standard.set(email, forKey: "profile_email") }
    }
    @Published var phone: String {
        didSet { UserDefaults.standard.set(phone, forKey: "profile_phone") }
    }

    init() {
        name  = UserDefaults.standard.string(forKey: "profile_name")  ?? ""
        email = UserDefaults.standard.string(forKey: "profile_email") ?? ""
        phone = UserDefaults.standard.string(forKey: "profile_phone") ?? ""
    }

    var isComplete: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
