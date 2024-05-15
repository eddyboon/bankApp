//
//  User.swift
//  bankApp
//
//  Created by Edward Ong on 1/5/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var phoneNumber: String
    var balance: Decimal
    var profileImageUrl: String?
    

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
    // Allow us to use mock user to test out fields without touching database
    static var MOCK_USER = User(id: NSUUID().uuidString, name: "Edward Ong", email: "test@gmail.com", phoneNumber: "0483214561", balance: 0.00)
}


