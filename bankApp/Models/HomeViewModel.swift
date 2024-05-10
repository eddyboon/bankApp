    //
    //  HomeViewModel.swift
    //  bankApp
    //
    //  Created by Byron Lester on 2/5/2024.
    //

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class HomeViewModel: ObservableObject {
    
    // @Published var mockUser = User.MOCK_USER
    @Published var transactions: [Transaction] = []
    @Published var isLoadingTransactions = false
    
    let db = Firestore.firestore()
    
    func fetchTransactions(authViewModel: AuthViewModel) async {
        
        guard let currentUser = authViewModel.currentUser else {
            print("No user found to fetch transactions.")
            return
        }
        
        isLoadingTransactions = true
        let transactionsRef = db.collection("users").document(currentUser.id).collection("Transactions")
        
        do {
            let querySnapshot = try await transactionsRef.getDocuments()
            self.transactions = querySnapshot.documents.compactMap { try? $0.data(as: Transaction.self) }
            self.transactions.sort {$0.date > $1.date } // Sort in descending order
            self.isLoadingTransactions = false
            
        } catch {
            self.isLoadingTransactions = false
            print("Failed to retrieve transactions: \(error)")
            
        }
        
        
    }
}
