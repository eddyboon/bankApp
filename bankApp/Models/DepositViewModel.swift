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
    @Published var depositAmount: Decimal = 0
    @Published var showDepositConfirmationView: Bool = false
    @Published var transactionDismissed: Bool = false
    
    let depositSuggestions: [Decimal] = [10, 50, 100].map { Decimal($0) }
    let db = Firestore.firestore()
    
    func depositMoney(depositAmount: Decimal, authViewModel: AuthViewModel) {
        guard let currentUser = authViewModel.currentUser else {
            print("Current user is nil")
            return
        }
        
        let newBalance = currentUser.balance + depositAmount
        
        FirestoreManager.shared.depositMoney(userId: currentUser.id, newBalance: newBalance, depositAmount: depositAmount) { success in
            if success {
                print("Balance update successful")
                authViewModel.currentUser?.balance += depositAmount
                self.showDepositConfirmationView = true
            }
            else {
                print("Failed to update balance.")
            }
        }
    }
}
