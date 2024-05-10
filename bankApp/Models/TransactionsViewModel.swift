//
//  TransactionsViewModel.swift
//  bankApp
//
//  Created by Byron Lester on 6/5/2024.
//

import Foundation


class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var filteredTransactions: [Transaction] = []
    @Published var filterDate: Date = Date()
    @Published var filterText: String = ""
    
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
        
        // Update filtered transactions whenever the filter text changes
        $filterText
                .receive(on: RunLoop.main) // Ensuring we're on the main thread
                .map { filter in
                    guard !filter.isEmpty else { return self.transactions }
                    return self.transactions.filter { transaction in
                        self.isMatch(transaction, searchText: filter)
                    }
                }
                .assign(to: &$filteredTransactions)
    }
    
    private func isMatch(_ transaction: Transaction, searchText: String) -> Bool {
        // Filter transactions by name, value, or date
        let searchTextLowercased = searchText.lowercased()
        return transaction.name.lowercased().contains(searchTextLowercased) ||
               "\(transaction.amount)".contains(searchTextLowercased) ||
               transaction.date.formatted(date: .numeric, time: .omitted).contains(searchTextLowercased)
    }
}
