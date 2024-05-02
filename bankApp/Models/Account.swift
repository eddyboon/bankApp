//
//  Account.swift
//  bankApp
//
//  Created by Byron Lester on 2/5/2024.
//

import Foundation

struct Account: Identifiable, Codable {
    let id: String
    let balance: String
    let userId: String
}

extension Account {
    static var MOCK_ACCOUNT = Account(id: "1", balance: "5000", userId: "1")
}
