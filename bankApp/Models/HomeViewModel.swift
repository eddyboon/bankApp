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
    @Published var user: User?
    @Published var isLoadingTransactions = false
    
    let db = Firestore.firestore()
    
    func fetchTransactions() async {
        
        guard let currentUser = user else {
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
    
    func setUser(user: User?) {
        self.user = user
    }
    
    func addTestTransaction() {
        guard let currentUser = user else {
            print("User not set before retrieving transactions.")
            return
        }
        
        let newTransaction = Transaction(
            id: NSUUID().uuidString,
            name: "Google", date: Date(),
            amount: 0.50,
            type: "credit"
        )
        
        do {
            try FirestoreManager.shared.addTransaction(userId: currentUser.id, transaction: newTransaction)
            
            self.transactions.append(newTransaction)
            self.transactions.sort { $0.date > $1.date }
            self.updateBalance(value: newTransaction.amount, transactionType: newTransaction.type)
            print("Transaction added to db and local list")
        }
        catch {
            print("Error adding transaction to Firestore \(error.localizedDescription)")
        }

    }
    
    func updateBalance(value: Decimal, transactionType: String) {
        if(transactionType == "debit") {
            self.user?.balance -= value
        }
        else {
            self.user?.balance += value
        }
    }
}
