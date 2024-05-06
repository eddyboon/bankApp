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
    @Published var depositAmount: Double = 0
    @Published var showDepositConfirmationView: Bool = false
    @Published var user: User?
    var authViewModel: AuthViewModel
    
    init(depositAmount: Double, showDepositConfirmationView: Bool, user: User? = nil, authViewModel: AuthViewModel) {
        self.depositAmount = depositAmount
        self.showDepositConfirmationView = showDepositConfirmationView
        self.user = user
        self.authViewModel = authViewModel
    }
    
    @MainActor
    func depositMoney(depositAmount: Double) {
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
}
