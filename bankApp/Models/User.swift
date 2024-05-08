//
//  User.swift
//  bankApp
//
//  Created by Edward Ong on 1/5/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let phoneNumber: String
    var balance: Decimal

    func displayBalance() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        guard let formattedBalance = formatter.string(from: balance as NSDecimalNumber) else {
            return "Invalid balance"
        }
        
        return formattedBalance
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, name: "Edward Ong", email: "test@gmail.com", balance: 0.00)
}
