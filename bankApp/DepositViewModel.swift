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
    
//    func depositMoney(depositAmount: Double) async throws {
//        // Add to current account balance in database
//        let database = Firestore.firestore()
//        
//    }
}
