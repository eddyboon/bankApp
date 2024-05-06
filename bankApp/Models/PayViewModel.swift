//
//  PayViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation

class PayViewModel: ObservableObject {
    @Published var doubleSpecifier: String = "%.2f"
    
    func getDoubleSpecifier(double: Double) -> String {
        if double.truncatingRemainder(dividingBy: 1) == 0 {
            return "%.f"
        }
        return "%.2f"
    }
}
