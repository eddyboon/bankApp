//
//  TransferConfirmationViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import Foundation

class TransferConfirmationViewModel: ObservableObject {
    @Published var transferAmount: Decimal
    @Published var transferRecipientName: String
    
    init(transferAmount: Decimal, transferRecipientName: String) {
        self.transferAmount = transferAmount
        self.transferRecipientName = transferRecipientName
    }
}
