//
//  PayViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation

class PayViewModel: ObservableObject {
    @Published var decimalSpecifier: String = "%.2f"
    
    func getDecimalSpecifier(decimal: Decimal) -> String {
        let roundedValue = NSDecimalNumber(decimal: decimal).rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)).decimalValue
        
        if decimal == roundedValue {
            return "%.0f"
        }
        return "%.2f"
    }
}

