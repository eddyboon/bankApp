    //
    //  HomeViewModel.swift
    //  bankApp
    //
    //  Created by Byron Lester on 2/5/2024.
    //

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = [] // Array to store recent transactions
    @Published var isLoadingTransactions = false // Flag for when progress view should be shown
    
    
    // Fetches the transaction from Firestore database
    func fetchTransactions(authViewModel: AuthViewModel) async {
        
        isLoadingTransactions = true
        
        // Checks for a currently logged in user
        guard let currentUser = authViewModel.currentUser else {
            print("No user found to fetch transactions.")
            return
        }
        
        do {
            // Uses FireStoreManager to fetch transactions.
            transactions = try await FirestoreManager.shared.fetchTransactions(userId: currentUser.id)
            isLoadingTransactions = false
        }
        catch {
            print("Error fetching transactions")
            isLoadingTransactions = false
        }
        
    }
}
