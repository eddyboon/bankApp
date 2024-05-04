    //
    //  HomeViewModel.swift
    //  bankApp
    //
    //  Created by Byron Lester on 2/5/2024.
    //

import Foundation
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    
    // @Published var mockUser = User.MOCK_USER
    @Published var transactions: [Transaction]? = []
    @Published var user: User?
    @Published var isLoadingTransactions = false
    
    let db = Firestore.firestore()
    
    @MainActor
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
            amount: 50.00,
            type: "debit"
        )
        
        let transactionsRef = db.collection("users").document(currentUser.id).collection("Transactions")
        
        do {
            let _ = try transactionsRef.addDocument(from: newTransaction) { error in
                if let error = error {
                    print("Error adding transaction to Firestore: \(error.localizedDescription)")
                }
                else {
                    DispatchQueue.main.async {
                        self.transactions?.append(newTransaction)
                        print("Transaction added to db and local list")
                    }
                }
                
            }
        }
        catch let error {
            print("Error adding transaction to firestore db: \(error.localizedDescription)")
        }

    }
}
