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
    let balance: Double
    var birthday: Date
    var profileImageUrl: String
    
    
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, name: "Edward Ong", email: "test@gmail.com", phoneNumber: "0483214561", balance: 0.00, birthday: Date(), profileImageUrl: "")
}


