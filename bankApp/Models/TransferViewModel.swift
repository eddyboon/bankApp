//
//  TransferViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation

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
    @Published var validRecipient: Bool = false
    @Published var validNumberInput: Bool = false
    @Published var validAmount: Bool = false
    @Published var errorMessage: String = ""
    @Published var numberErrorMessage: String = ""
    @Published var undergoingNetworkRequests = false
    
    let transferSuggestions = [10, 50, 100]
    
    let numberErrorMessages = ["Recipient not found ❌", "Cannot send money to yourself ❌"]

    func transferMoney(authViewModel: AuthViewModel) async {
        
        // Set flag to indicate pending network request
        undergoingNetworkRequests = true
        
        // Convert string into decimal value. Force unwrapped as input validation ensures value can be converted to a decimal.
        transferAmount = Decimal(string: transferAmountString)!
        
        // Ensure current user exists
        guard let currentUser = authViewModel.currentUser else {
            print("Current user ID is nil")
            undergoingNetworkRequests = false
            return
        }
        
        // Ensure the transfer recipient exists
        guard let transferRecipient = self.transferRecipient else {
            print("Transfer recipient is nil")
            undergoingNetworkRequests = false
            return
        }
        
        let newBalance = currentUser.balance - transferAmount // The new balance of the sender
        let newRecipientBalance = transferRecipient.balance + transferAmount // The new balance of the recipient
        
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
            errorMessage = "Error. Please try again."
        }
    }
    
    // Gets the recipient from the database
    func getRecipient(phoneNumber: String, senderPhoneNumber: String) async {
        
        if(phoneNumber == senderPhoneNumber) {
            numberErrorMessage = numberErrorMessages[1]
            userFetching = false
            validRecipient = false
            return
        }
        
        do {
            // Initiate request using Firestore Manager
            transferRecipient = try await FirestoreManager.shared.getRecipient(phoneNumber: phoneNumber)
            // If non nil value returned, a valid recipient exists
            if(transferRecipient != nil) {
                validRecipient = true
                userFetching = false
                numberErrorMessage = numberErrorMessages[0]
            }
            else {
                numberErrorMessage = ""
                userFetching = false
                validRecipient = false
            }
        }
        catch {
            print("Network error: \(error)")
        }
    }
    
    func validateAmount(authViewModel: AuthViewModel) {
        
        // Use inputvalidation regex to ensure correct number format
        if(!InputValidation.isValidMoneyAmount(transferAmountString)) {
            validAmount = false
            return
        }
        
        // Unwrap the string to a decimal
        if let transferAmountDec = Decimal(string: transferAmountString) {
            // This should always be true.
            if let currentUser = authViewModel.currentUser {
                
                // Check the user has enough funds available
                if(currentUser.balance - transferAmountDec < 0) {
                    errorMessage = "Your balance is too low ($\(currentUser.balance)) ❌"
                    validAmount = false
                    return
                }
                // Prevent an input beginning with zero
                if(transferAmountDec == 0) {
                    transferAmountString = ""
                }
                if (transferAmountDec >= 1000000) {
                    errorMessage = "The transfer limit is less than 1 Million. #TooRich4Me"
                    validAmount = false
                    return
                }
            }
        }
        // All checks passed
        errorMessage = ""
        validAmount = true
        
        
    }
    
    func ensurePhoneNumberFormat() {
    
        // Ensure number begins in 04
        if !recipientNumber.hasPrefix("04") {
            recipientNumber = "04"
        }
        // Ensure number doesn't exceed 10 digits
        if(recipientNumber.count > 10) {
            recipientNumber = String(recipientNumber.prefix(10))
        }
        // Valid input if and only if digit count is 10 and is a number
        if(recipientNumber.count == 10 && recipientNumber.allSatisfy(\.isNumber)) {
            validNumberInput = true
        }
        // Otherwise false
        else {
            validNumberInput = false
            validRecipient = false
            checkButtonPressed = false
        }
    }
    
}
