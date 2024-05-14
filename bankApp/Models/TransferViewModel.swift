//
//  TransferViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class TransferViewModel: ObservableObject {
    @Published var transferAmount: Decimal = 0
    @Published var showTransferConfirmationView: Bool = false
    @Published var transactionDismissed: Bool = false
    @Published var recipientNumber: String = "04"
    @Published var transferRecipient: User?  = nil
    @Published var transferAmountString: String = ""
    @Published var checkButtonPressed: Bool = false
    @Published var userFetching: Bool = false
    let transferSuggestions = [10, 50, 100]
    @Published var validRecipient: Bool = false
    @Published var validNumberInput: Bool = false
    @Published var validAmount: Bool = false
    @Published var errorMessage: String = ""
    @Published var undergoingNetworkRequests = false

    
    var screenSize: CGSize? = nil
    
    let db = Firestore.firestore()
    
    func transferMoney(authViewModel: AuthViewModel) async {
        
        print("ValidRecipient value: \(validRecipient)")
        
        undergoingNetworkRequests = true
        
        transferAmount = Decimal(string: transferAmountString)!
        
        // Ensure current user is not nil
        guard let currentUser = authViewModel.currentUser else {
            print("Current user ID is nil")
            undergoingNetworkRequests = false
            return
        }
        
        // Ensure the transfer recipient
        guard let transferRecipient = self.transferRecipient else {
            print("Transfer recipient is nil")
            undergoingNetworkRequests = false
            return
        }
        
        let newBalance = currentUser.balance - transferAmount
        let newRecipientBalance = transferRecipient.balance + transferAmount
        
        // Check that sender has sufficient funds.
        if(newBalance < 0) {
            print("User has insufficent funds")
            undergoingNetworkRequests = false
            return
        }
            
        // Undergo the transfer, if successful, show confirmation screen
        let successful = await FirestoreManager.shared.transferMoney(sender: currentUser, recipient: transferRecipient, newSenderBalance: newBalance, newRecipientBalance: newRecipientBalance,  amount: transferAmount)
        
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
    
    func getRecipient(phoneNumber: String) async {
        
        let usersRef = db.collection("users")
        
        let field = "phoneNumber"
        let value = phoneNumber
        
        do {
            let querySnapshot = try await usersRef.whereField(field, isEqualTo: value).getDocuments()
            if let document = querySnapshot.documents.first {
                transferRecipient = try document.data(as: User.self)
                validRecipient = true
                userFetching = false
            } else {
                print("No user found matching phone number")
                userFetching = false
            }
        }
        catch {
            userFetching = false
            print("Error fetching recipient name")
        }
    }
    
    func validateAmount(authViewModel: AuthViewModel) {
        
        if(!isValidMoneyAmount(amountString: transferAmountString)) {
            validAmount = false
            return
        }
        
        // Input must be a number if this is true.
        if let transferAmountDec = Decimal(string: transferAmountString) {
            // This should always be true.
            if let currentUser = authViewModel.currentUser {
                if(transferAmountDec >= 100000) {
                    errorMessage = "Your transfer limit is $100,000 ❌"
                    validAmount = false
                    return
                }
                else if(currentUser.balance - transferAmountDec < 0) {
                    errorMessage = "Your balance is too low ($\(currentUser.balance)) ❌"
                    validAmount = false
                    return
                }
                
                if(transferAmountDec == 0) {
                    transferAmountString = ""
                }
            }
        }
        
        errorMessage = ""
        validAmount = true
        
        
    }
    
    func ensurePhoneNumberFormat() {
    
        
        if !recipientNumber.hasPrefix("04") {
            recipientNumber = "04"
        }
        
        if(recipientNumber.count > 10) {
            recipientNumber = String(recipientNumber.prefix(10))
        }
        
        
        if recipientNumber.count == 10 {
            validNumberInput = true
        }
        else {
            validNumberInput = false
            validRecipient = false
            checkButtonPressed = false
        }
    }
    
    func isValidMoneyAmount(amountString: String) -> Bool {
        let pattern = #"^\d+(\.\d{1,2})?$"# // Regular expression pattern to match valid money amounts
        guard let regex = try? NSRegularExpression(pattern: pattern) else { // Create a regular expression object
            return false
        }
        let range = NSRange(location: 0, length: amountString.utf16.count)
        return regex.firstMatch(in: amountString, options: [], range: range) != nil
    }
    
}
