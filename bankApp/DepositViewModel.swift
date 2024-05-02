//
//  DepositViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation

class DepositViewModel: ObservableObject {
    @Published var depositAmount: Double = 0
    @Published var showDepositConfirmationView: Bool = false
    
    func depositMoney(depositAmount: Double) {
        // Add to current account balance in database
    }
}
