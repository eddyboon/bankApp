//
//  DepositViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class DepositViewModel: ObservableObject {
    @Published var depositAmountString: String = ""
    @Published var depositAmount: Decimal = 0
    @Published var showDepositConfirmationView: Bool = false
    @Published var transactionDismissed: Bool = false
    @Published var requestInProgress: Bool = false
    @Published var validAmount: Bool = false
    
    let depositSuggestions = [10, 50, 100]
    
    let db = Firestore.firestore()
    
    func depositMoney(depositAmountString: String, authViewModel: AuthViewModel) async {
        requestInProgress = true
        
        self.depositAmount = Decimal(string: depositAmountString) ?? Decimal()
        
        guard self.depositAmount != Decimal.zero else {
            print("Invalid amount")
            return
        }
        
        guard let currentUser = authViewModel.currentUser else {
            print("Current user is nil")
            return
        }
        
        let newBalance = currentUser.balance + depositAmount
        
        let success = await FirestoreManager.shared.depositMoney(userId: currentUser.id, senderName: "Deposit", newBalance: newBalance, depositAmount: depositAmount)
        
        if success {
            requestInProgress = false
            print("Balance update successful")
            authViewModel.currentUser?.balance += depositAmount
            self.showDepositConfirmationView = true
        }
        else {
            requestInProgress = false
            print("Failed to update balance.")
        }
    }
    
    func validateAmount() {
        if depositAmountString.count > 7 {
            depositAmountString = String(depositAmountString.prefix(7))
            depositAmount = Decimal(string: depositAmountString) ?? 0
        }
        if let actualAmount = Decimal(string: depositAmountString), actualAmount > 0 && depositAmountString.count < 8 && isValidMoneyAmount(amountString: depositAmountString) {
            validAmount = true
            depositAmount = Decimal(string: depositAmountString) ?? 0
        }
        else {
            validAmount = false
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
