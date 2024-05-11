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
                            print("Error adding transaction for \(userId) to Firestore: \(error.localizedDescription)")
                        } else {
                            print("Transaction added successfully")
                        }
                    }
                } catch let error {
                    print("Error adding transaction for \(userId) to Firestore: \(error.localizedDescription)")
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
        
        let success = await depositMoney(userId: recipient.id, senderName: sender.name, newBalance: newRecipientBalance, depositAmount: amount)
        
        if success {
            print("Transfer deposit successful")
        }
        else {
            print("Transfer deposit unsuccessful")
            return false

        }
        
        // Deduct money from sender account
        do {
            try await senderRef.updateData(["balance": newSenderBalance])
        }
        catch {
            print("Error updating sender balance.")
            return false
        }
        
        // Add money to recipient account
        do {
            try await recipientRef.updateData(["balance": newRecipientBalance])
        }
        catch {
            print("Error updating recipient balance")
            return false
        }
        
        
        // Prepare recipient transaction record
        let recipientTransaction = Transaction(id: NSUUID().uuidString, name: "Transfer from \(sender.name)", date: Date(), amount: amount, type: "credit")
        
        // Prepare sender transaction record
        let senderTransaction = Transaction(id: NSUUID().uuidString, name: "Transfer to \(recipient.name)", date: Date(), amount: amount, type: "debit")
        
        do {
            try addTransaction(userId: recipient.id, transaction: recipientTransaction)
            try addTransaction(userId: sender.id, transaction: senderTransaction)
        }
        catch {
            print("Error updating transactions.")
            return false
        }
        
        print("All transfer operations successful")
        return true
        
    }
}
