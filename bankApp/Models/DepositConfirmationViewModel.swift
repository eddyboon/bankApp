//
//  DepositConfirmationViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import Foundation

class DepositConfirmationViewModel: ObservableObject {
    @Published var depositAmount: Decimal
    
    init(depositAmount: Decimal) {
        self.depositAmount = depositAmount
    }
}
