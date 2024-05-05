//
//  TransferViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation

class TransferViewModel: ObservableObject {
    @Published var transferAmount: Double = 0
    @Published var showTransferConfirmationView: Bool = false
    
    func transferMoney(transferAmount: Double) {
        // Add to current account balance in database
    }
}
