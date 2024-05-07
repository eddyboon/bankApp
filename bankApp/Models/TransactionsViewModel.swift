//
//  TransactionsViewModel.swift
//  bankApp
//
//  Created by Byron Lester on 6/5/2024.
//

import Foundation


class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var filterDate: Date = Date()
    @Published var filterName: String = ""
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
}
