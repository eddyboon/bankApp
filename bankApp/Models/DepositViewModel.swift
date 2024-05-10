//
//  DepositViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class DepositViewModel: ObservableObject {
    @Published var depositAmount: Decimal = 0
    @Published var depositAmountString: String = ""
    @Published var validAmount: Bool = false
    @Published var showDepositConfirmationView: Bool = false
    @Published var user: User?
    let depositSuggestions: [Decimal] = [10, 50, 100].map { Decimal($0) }
    var authViewModel: AuthViewModel
    
    init(depositAmount: Decimal, showDepositConfirmationView: Bool, user: User? = nil, authViewModel: AuthViewModel) {
        self.depositAmount = depositAmount
        self.showDepositConfirmationView = showDepositConfirmationView
        self.user = user
        self.authViewModel = authViewModel
    }
    
    @MainActor
    func depositMoney(depositAmount: Decimal) {
        guard let currentUserID = authViewModel.currentUser?.id else {
            print("Current user ID is nil")
            return
        }
        let database = Firestore.firestore()
        database.collection("users").document(currentUserID).getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching balance: \(error.localizedDescription)")
                return
            }
            guard let document = documentSnapshot, document.exists else {
                print("Document does not exist")
                return
            }
            do {
                let user = try document.data(as: User.self)
                let newBalance = (user.balance) + depositAmount
                database.collection("users").document(currentUserID).updateData(["balance": newBalance]) { error in
                    if let error = error {
                        print("Error updating balance: \(error.localizedDescription)")
                    }
                    else {
                        print("Total amount updated successfully")
                    }
                }
            }
            catch {
                print("Error getting user document: \(error.localizedDescription)")
            }
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
