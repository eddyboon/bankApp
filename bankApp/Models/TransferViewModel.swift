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
    
    init(transferAmount: Decimal, showTransferConfirmationView: Bool, authViewModel: AuthViewModel) {
        self.transferAmount = transferAmount
        self.showTransferConfirmationView = showTransferConfirmationView
        self.authViewModel = authViewModel
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
    func getRecipientName(phoneNumber: String) -> String {
        var recipientName = ""
        let database = Firestore.firestore()
        let phoneNo = phoneNumber
        
        database.collection("users").whereField("phoneNumber", isEqualTo: phoneNo)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching recipient name: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents, documents.count > 0 else {
                    return
                }
                let document = documents.first!
                do {
                    let recipient = try document.data(as: User.self)
                    recipientName = recipient.name
                } catch {
                    print("Error getting recipient data: \(error.localizedDescription)")
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
//            transferRecipientName = getRecipientName(phoneNumber: transferRecipient)
//            if transferRecipientName != "" {
//                validRecipient = true
//            }
//            else {
//                validRecipient = false
//            }
        }
        else {
            validRecipient = false
        }
    }
    
    func validateAmount() {
        if transferAmountString.count > 10 {
            transferAmountString = String(transferAmountString.prefix(10))
            transferAmount = Decimal(string: transferAmountString) ?? 0
        }
        if let actualAmount = Decimal(string: transferAmountString), actualAmount > 0 && transferAmountString.count < 11 {
            validAmount = true
            transferAmount = Decimal(string: transferAmountString) ?? 0
        } else {
            validAmount = false
        }
    }
}
