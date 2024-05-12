    //
    //  HomeViewModel.swift
    //  bankApp
    //
    //  Created by Byron Lester on 2/5/2024.
    //

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    // @Published var mockUser = User.MOCK_USER
    @Published var transactions: [Transaction] = []
    @Published var isLoadingTransactions = false
    
    
    func fetchTransactions(authViewModel: AuthViewModel) async {
        
        isLoadingTransactions = true
        
        guard let currentUser = authViewModel.currentUser else {
            print("No user found to fetch transactions.")
            return
        }
        
        do {
            transactions = try await FirestoreManager.shared.fetchTransactions(userId: currentUser.id)
            isLoadingTransactions = false
        }
        catch {
            print("Error fetching transactions")
            isLoadingTransactions = false
        }
        
    }
}
