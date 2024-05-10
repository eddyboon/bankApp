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
    
    func depositMoney(userId: String, newBalance: Decimal, depositAmount: Decimal, completion: @escaping (Bool) -> Void) {
        
        let depositRef = db.collection("users").document(userId)
        
        // Update the user's balance
        depositRef.updateData(["balance": newBalance]) { error in
            if let error = error {
                print("Error updating balance: \(error.localizedDescription).")
                return completion(false)
            }
            else {
                print("New balance updated successfully.")
            }
        }
        
        // Prepare the transaction
        let newTransaction = Transaction(id: NSUUID().uuidString,
                                         name: "Deposit", date: Date(),
                                         amount: depositAmount,
                                         type: "credit")
        
        // Add deposit transaction to user's transactions.
        do {
            try addTransaction(userId: userId, transaction: newTransaction)
            return completion(true)
        }
        catch {
            print("Failed to add deposit transaction to user's transactions.")
            depositRef.updateData(["balance": newBalance - depositAmount])
            return completion(false)
        }
    }
}
