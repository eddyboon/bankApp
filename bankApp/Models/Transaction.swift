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
    let date : Date
    let amount : Decimal
    let type: String
    
}

extension Transaction {
    
    static var Mock_Transactions : [Transaction] =
    [
        .init(id: NSUUID().uuidString, name: "Netflix", date: Date(), amount: 9.00, type: "debit"),
        .init(id: NSUUID().uuidString, name: "Vodafone", date: Date(), amount: 100.00, type: "debit"),
        .init(id: NSUUID().uuidString, name: "Apple", date: Date(), amount:  14.00, type: "debit"),
        .init(id: NSUUID().uuidString, name: "Google", date: Date(), amount: 10.00, type: "debit"),
    ]
}
