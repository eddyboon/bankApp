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
    @Published var transferRecipient: String = "04"
    @Published var transferRecipientName: String = ""
    @Published var transferAmountString: String = ""
    let transferSuggestions = [10, 50, 100]
    @Published var validRecipient: Bool = false
    @Published var validAmount: Bool = false
    var authViewModel: AuthViewModel
    @Published var recipientFound: Bool = false
    @Published var recipientChecked: Bool = false
    @Published var recipientNameChecked: Bool = false
    @Published var currentBalance: Decimal = 0
    
    init(transferAmount: Decimal, showTransferConfirmationView: Bool, authViewModel: AuthViewModel) {
        self.transferAmount = transferAmount
        self.showTransferConfirmationView = showTransferConfirmationView
        self.authViewModel = authViewModel
        Task {
            try await getCurrentBalance()
            print(currentBalance)
        }
    }
    
    @MainActor
    func getCurrentBalance() async throws {
        guard let currentUserID = authViewModel.currentUser?.id else {
            print("Current user ID is nil")
            return
        }
        do {
            let documentSnapshot = try await Firestore.firestore().collection("users").document(currentUserID).getDocument()
            guard documentSnapshot.exists else {
                print("Document does not exist")
                return
            }
            let user = try documentSnapshot.data(as: User.self)
            self.currentBalance = user.balance
            print(currentBalance)
        } catch {
            print("Error fetching balance: \(error.localizedDescription)")
        }
    }
    
    
    @MainActor
    func transferMoney(transferAmount: Decimal, recipientPhoneNo: String) {
        // Deducts from balance but does not add to other persons account balance yet
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
                let newBalance = (user.balance) - transferAmount
                if newBalance < 0 {
                    print("Balance is too low")
                    return
                }
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
            // Update recipient's balance
            let database = Firestore.firestore()
            database.collection("users").whereField("phoneNumber", isEqualTo: recipientPhoneNo)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching recipient data: \(error.localizedDescription)")
                        return
                    }
                    guard let documents = querySnapshot?.documents, documents.count > 0 else {
                        print("Recipient not found")
                        return
                    }
                    let document = documents.first!
                    
                    // Calculate new recipient balance
                    var newRecipientBalance: Decimal = 0.0
                    if let currentBalance = document.data()["balance"] as? Decimal {
                        newRecipientBalance = currentBalance + transferAmount
                    } else {
                        // Handle case where recipient doesn't have a balance field (set to 0?)
                        newRecipientBalance = transferAmount
                    }
                    
                    // Update recipient's balance
                    database.collection("users").document(document.documentID).updateData(["balance": newRecipientBalance]) { error in
                        if let error = error {
                            print("Error updating recipient balance: \(error.localizedDescription)")
                        } else {
                            print("Recipient balance updated successfully")
                        }
                    }
                }
        }
    }
    @MainActor
    func getRecipientName(phoneNumber: String) async throws -> String {
        var recipientName = ""
        let querySnapshot = try await Firestore.firestore().collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments()
        if(querySnapshot.isEmpty) {
            print("Phone number not found")
            recipientFound = false
            return recipientName
        }
        else {
            for document in querySnapshot.documents {
                print(document.data()["name"] ?? "")
                recipientName = document.data()["name"] as! String
                recipientFound = true
                return recipientName
            }
        }
        return recipientName // This will be empty initially, filled asynchronously
    }
    
    func validateRecipient() {
        if !transferRecipient.hasPrefix("04") {
            transferRecipient = "04"
            return
        }
        if transferRecipient.count > 10 {
            transferRecipient = String(transferRecipient.prefix(10))
            return
        }
        if(transferRecipient.count == 10 && transferRecipient.allSatisfy(\.isNumber)) {
            validRecipient = true
        }
        else {
            validRecipient = false
        }
    }
    
    func validateAmount() {
        if transferAmountString.count > 7 {
            transferAmountString = String(transferAmountString.prefix(7))
            transferAmount = Decimal(string: transferAmountString) ?? 0
        }
        if let actualAmount = Decimal(string: transferAmountString), actualAmount > 0 && transferAmountString.count < 8 && isValidMoneyAmount(amountString: transferAmountString) {
            validAmount = true
            transferAmount = Decimal(string: transferAmountString) ?? 0
        } else {
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
