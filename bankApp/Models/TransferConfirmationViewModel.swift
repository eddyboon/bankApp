//
//  TransferConfirmationViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import Foundation

class TransferConfirmationViewModel: ObservableObject {
    @Published var transferAmount: Decimal // The amount to display in the confirmation
    @Published var transferRecipientName: String // The recipient name to display in the confirmation
    
    init(transferAmount: Decimal, transferRecipientName: String) {
        self.transferAmount = transferAmount
        self.transferRecipientName = transferRecipientName
    }
}
