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
    
    func validateInput() {
        if(depositAmountString == "" || depositAmountString == "0") {
            depositAmountString = ""
            validAmount = false
            return
        }
        
        if(depositAmountString.contains(".")) {
            let decimalCount = depositAmountString.filter {$0 == "."}.count
            
            if decimalCount > 1 {
                if let lastDecimalIndex = depositAmountString.lastIndex(of: ".") {
                    depositAmountString = String(depositAmountString.prefix(upTo: lastDecimalIndex))
                }
            }
            
            let numberSplit = depositAmountString.split(separator: ".")
            
            // Check if there are more than two decimal places after the decimal point
            if numberSplit.count > 1 && numberSplit[1].count > 2 {
                // If more than two decimal places, truncate to two decimal places
                let truncatedDecimal = numberSplit[1].prefix(2)
                depositAmountString = "\(numberSplit[0]).\(truncatedDecimal)"
            }
        }
        
        validAmount = true
    }
}
