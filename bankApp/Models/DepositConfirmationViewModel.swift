//
//  DepositConfirmationViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import Foundation

class DepositConfirmationViewModel: ObservableObject {
    @Published var depositSpecifier: String = "%.2f"
    
    func getDepositSpecifier(double: Double) -> String {
        if double.truncatingRemainder(dividingBy: 1) == 0 {
            return "%.f"
        }
        return "%.2f"
    }
}
