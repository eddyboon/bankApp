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
    
    @Published var mockUser = User.MOCK_USER
    @Published var transactions: [Transaction]? = []
    @Published var user: User?
    @Published var isLoadingTransactions = false
    
    let db = Firestore.firestore()
    
    func fetchTransactions() async {
        if let currentUser = self.user {
            let transactionsRef = db.collection("users").document(currentUser.id).collection("Transactions")
            
            do {
                let querySnapshot = try await transactionsRef.getDocuments()
                self.transactions = querySnapshot.documents.compactMap({ document in
                    try? document.data(as: Transaction.self)
                })  
            }
            catch {
                print("Failed to retrieve transactions: \(error)")
            }
        }
        else {
            print("HomeViewModel knows of no user to fetch.")
        }
    }
    
    func setUser(user: User?) {
        self.user = user
    }
    
    func addTestTransaction() {
        
    }
}
