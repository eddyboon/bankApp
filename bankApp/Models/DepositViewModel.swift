//
//  DepositViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation

class DepositViewModel: ObservableObject {
    @Published var depositAmountString: String = ""
    @Published var depositAmount: Decimal = 0
    @Published var showDepositConfirmationView: Bool = false
    @Published var transactionDismissed: Bool = false
    @Published var requestInProgress: Bool = false
    @Published var validAmount: Bool = false
    @Published var errorMessage: String = ""
    @Published var showErrorMessage: Bool = false
    
    let depositSuggestions = [10, 50, 100]
    
    
    @MainActor
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
        
        depositAmount = Decimal(string: depositAmountString) ?? Decimal()
        
        if(depositAmount > 1000000) {
            showErrorMessage = true
            errorMessage = "Dude, you've got way too much money. Deposit limit is 1,000,000! 😬"
            validAmount = false
            return
        }
        
        validAmount = InputValidation.isValidMoneyAmount(depositAmountString)
        
        errorMessage = ""
        showErrorMessage = false
    }
    
    
}
