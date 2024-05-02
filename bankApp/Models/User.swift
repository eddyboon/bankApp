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
    let totalAmount: String
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, name: "Edward Ong", email: "test@gmail.com", totalAmount: "0.00")
}
