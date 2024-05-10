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
    
    func depositMoney(userId: String, senderName: String, newBalance: Decimal, depositAmount: Decimal) async -> Bool {
            let depositRef = db.collection("users").document(userId)

            do {
                // Update the user's balance
                try await depositRef.updateData(["balance": newBalance])
                print("New balance updated successfully.")

                // Prepare the transaction
                let newTransaction = Transaction(id: NSUUID().uuidString,
                                                 name: senderName, date: Date(),
                                                 amount: depositAmount,
                                                 type: "credit")

                // Add deposit transaction to user's transactions
                try addTransaction(userId: userId, transaction: newTransaction)
                return true
            } catch {
                print("Failed to update balance or add deposit transaction: \(error.localizedDescription)")
                // Revert the balance update if an error occurred
                try? await depositRef.updateData(["balance": newBalance - depositAmount])
                return false
            }
    }
    
    func transferMoney(sender: User, recipient: User, newSenderBalance: Decimal, newRecipientBalance: Decimal, amount: Decimal) async -> Bool {
        
        let senderRef = db.collection("users").document(sender.id)
        let recipientRef = db.collection("users").document(recipient.id)
        
        await depositMoney(userId: recipient.id, senderName: sender.name, newBalance: newRecipientBalance, depositAmount: amount)
        
        return false
        
        
    }
}
