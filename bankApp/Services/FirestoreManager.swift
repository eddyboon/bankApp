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
    
    // Adds a new transaction to the user's transaction list
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
    
    // Updates user balance and adds the deposit to the transaction list
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
    
    // Deducts funds from the sender and adds funds to the recipient. Adds the relevant transaction to both users
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
    
    func fetchTransactions(userId: String) async throws -> [Transaction] {
        
        var transactions: [Transaction]
        
        let transactionsRef = db.collection("users").document(userId).collection("Transactions")
        
        let querySnapshot = try await transactionsRef.getDocuments()
        transactions = querySnapshot.documents.compactMap { try? $0.data(as: Transaction.self) }
        transactions.sort {$0.date > $1.date } // Sort in descending order
        
        return transactions

       
    }
    // Gets the recipient using a phone number
    func getRecipient(phoneNumber: String) async throws -> User? {
        
        let usersRef = db.collection("users")
        let field = "phoneNumber"
        let value = phoneNumber
        
        do {
            let querySnapshot = try await usersRef.whereField(field, isEqualTo: value).getDocuments()
            if let document = querySnapshot.documents.first {
                let transferRecipient = try document.data(as: User.self)
                print("User found")
                return transferRecipient
            } else {
                // No user found
                print("No user found")
                return nil
            }
        }
        catch {
            throw error
        }
    }
    
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageUrl" : imageUrl
        ])
        
    }
}
