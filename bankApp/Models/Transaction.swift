//
//  Transaction.swift
//  bankApp
//
//  Created by Byron Lester on 2/5/2024.
//

import Foundation

struct Transaction : Identifiable, Codable, Hashable {
    
    let id : String
    let name : String
    let date : String
    let value : String
    let type: String
    
}

extension Transaction {
    
    static var Mock_Transactions : [Transaction] =
    [
        .init(id: NSUUID().uuidString, name: "Netflix", date: Date().formatted(), value: "9.00", type: "debit"),
        .init(id: NSUUID().uuidString, name: "Vodafone", date: Date().formatted(), value: "100.00", type: "debit"),
        .init(id: NSUUID().uuidString, name: "Apple", date: Date().formatted(), value:  "14.00", type: "debit"),
        .init(id: NSUUID().uuidString, name: "Google", date: Date().formatted(), value: "10.00", type: "debit"),
    ]
}
