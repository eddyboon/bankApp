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
    @Published var transferAmount: Double = 0
    @Published var showTransferConfirmationView: Bool = false
    @Published var transferRecipient: String = "04"
    @Published var transferRecipientName: String = ""
    @Published var transferAmountString: String = ""
    let transferSuggestions = [10, 50, 100]
    @Published var validRecipient: Bool = false
    @Published var validAmount: Bool = false
    var authViewModel: AuthViewModel
    
    init(transferAmount: Double, showTransferConfirmationView: Bool, authViewModel: AuthViewModel) {
        self.transferAmount = transferAmount
        self.showTransferConfirmationView = showTransferConfirmationView
        self.authViewModel = authViewModel
    }
    
    @MainActor
    func transferMoney(transferAmount: Double) {
        //        guard let currentUserID = authViewModel.currentUser?.id else {
        //            print("Current user ID is nil")
        //            return
        //        }
        //        let database = Firestore.firestore()
        //        database.collection("users").document(currentUserID).getDocument { documentSnapshot, error in
        //            if let error = error {
        //                print("Error fetching balance: \(error.localizedDescription)")
        //                return
        //            }
        //            guard let document = documentSnapshot, document.exists else {
        //                print("Document does not exist")
        //                return
        //            }
        //            do {
        //                let user = try document.data(as: User.self)
        //                let newBalance = (user.balance) + depositAmount
        //                database.collection("users").document(currentUserID).updateData(["balance": newBalance]) { error in
        //                    if let error = error {
        //                        print("Error updating balance: \(error.localizedDescription)")
        //                    }
        //                    else {
        //                        print("Total amount updated successfully")
        //                    }
        //                }
        //            }
        //            catch {
        //                print("Error getting user document: \(error.localizedDescription)")
        //            }
        //        }
    }
    func getRecipientName(phoneNumber: String) -> String {
        let query = Firestore.firestore().collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).limit(to: 1)
        var userName = ""
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, let user = documents.first?.data(), let name = user["name"] as? String else {
                print("Error fetching user's name: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            userName = name
        }
        return userName
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
            transferRecipientName = getRecipientName(phoneNumber: transferRecipient)
            if transferRecipientName != "" {
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
        if let actualAmount = Double(transferAmountString), actualAmount > 0 && transferAmountString.count < 11 {
            validAmount = true
        }
        else {
            validAmount = false
        }
    }
}
