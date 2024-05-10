//
//  FirestoreManager.swift
//  bankApp
//
//  Created by Byron Lester on 10/5/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    
    func addTransaction(userId: String, transaction: Transaction) throws {
        
        let transactionsRef = db.collection("users").document(userId).collection("Transactions")

                do {
                    try transactionsRef.addDocument(from: transaction) { error in
                        if let error = error {
                            print("Error adding transaction to Firestore: \(error.localizedDescription)")
                        } else {
                            print("Transaction added successfully")
                        }
                    }
                } catch let error {
                    print("Error adding transaction to Firestore: \(error.localizedDescription)")
                }
    }
    
    func depositMoney(userId: String, newBalance: Decimal, completion: @escaping (Bool) -> Void) {
        
        let depositRef = db.collection("users").document(userId)
        
        depositRef.updateData(["balance": newBalance]) { error in
            if let error = error {
                print("Error updating balance: \(error.localizedDescription).")
                return completion(false)
            }
            else {
                print("New balance updated successfully.")
                return completion(true)
            }
        }
    }
}
