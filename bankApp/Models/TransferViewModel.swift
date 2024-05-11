//
//  TransferViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class TransferViewModel: ObservableObject {
    @Published var transferAmount: Decimal = 0
    @Published var showTransferConfirmationView: Bool = false
    @Published var transactionDismissed: Bool = false
    @Published var recipientNumber: String = "04"
    @Published var transferRecipient: User?  = nil
    @Published var transferAmountString: String = ""
    let transferSuggestions = [10, 50, 100]
    @Published var validRecipient: Bool = false
    @Published var validAmount: Bool = false
    @Published var errorMessage: String = ""
    @Published var undergoingNetworkRequests = false
    
    let db = Firestore.firestore()
    
    
    @MainActor
    func transferMoney(authViewModel: AuthViewModel) async {
        
        undergoingNetworkRequests = true
        // Deducts from balance but does not add to other persons account balance yet
        guard let currentUser = authViewModel.currentUser else {
            print("Current user ID is nil")
            undergoingNetworkRequests = false
            return
        }
        
        // Check for valid recipient
        if let recipient = await getRecipient(phoneNumber: self.recipientNumber) {
            
            transferRecipient = recipient
            
            let newBalance = currentUser.balance - transferAmount
            let newRecipientBalance = recipient.balance + transferAmount
            
            // Check that sender has sufficient funds.
            if(newBalance < 0) {
                print("User has insufficent funds")
                undergoingNetworkRequests = false
                return
            }
            
            // Undergo the transfer, if successful, show confirmation screen
            let successful = await FirestoreManager.shared.transferMoney(sender: currentUser, recipient: recipient, newSenderBalance: newBalance, newRecipientBalance: newRecipientBalance,  amount: transferAmount)
            
            if successful {
                authViewModel.currentUser?.balance = newBalance
                undergoingNetworkRequests = false
                showTransferConfirmationView = true
            }
            else {
                undergoingNetworkRequests = false
                errorMessage = "Network error. Please try again."
            }
        }
        else {
            print("Invalid recipient.")
        }
    }
    
    func getRecipient(phoneNumber: String) async -> User? {
        
        let usersRef = db.collection("users")
        
        let field = "phoneNumber"
        let value = phoneNumber
        
        do {
            let querySnapshot = try await usersRef.whereField(field, isEqualTo: value).getDocuments()
            if let document = querySnapshot.documents.first {
                let user = try document.data(as: User.self)
                print("Recipient Name: \(user.name)")
                return user
            } else {
                print("No user found matching phone number")
                return nil
            }
        }
        catch {
            print("Error fetching recipient name")
            return nil
        }
    }
    
    func validateRecipient() async {
       
        if recipientNumber.count > 10 {
            recipientNumber = String(recipientNumber.prefix(10))
            return
        }
        if(recipientNumber.count == 10 && recipientNumber.allSatisfy(\.isNumber)) {
            transferRecipient = await getRecipient(phoneNumber: recipientNumber)
            if transferRecipient?.name != "" {
                validRecipient = true
            }
            else {
                validRecipient = false
            }
        }
        else {
            validRecipient = false
        }
    }
    
    
    func validateAmount() {
        if transferAmountString.count > 10 {
            transferAmountString = String(transferAmountString.prefix(10))
        }
        if let actualAmount = Decimal(string: transferAmountString), actualAmount > 0 && transferAmountString.count < 11 {
            validAmount = true
        } else {
            validAmount = false
        }
    }
    
    func ensureNumberFormat() {
        if !recipientNumber.hasPrefix("04") {
            recipientNumber = "04"
        }
    }
    
}
