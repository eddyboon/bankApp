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
    
    func depositMoney(depositAmount: Double) {
        //        // Add to current account balance in database
        //        guard let currentUserID = authViewModel.currentUser?.id else {
        //            print("Current user ID is nil")
        //            return
        //        }
        //        let database = Firestore.firestore()
        //        database.collection("users").document(currentUserID).setData(["totalAmount": depositAmount], merge: true) { error in
        //            if let error = error {
        //                print("Error depositing money: \(error.localizedDescription)")
        //            } else {
        //                print("Money deposited successfully")
        //            }
        //        }
    }
}
