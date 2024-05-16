//
//  InputValidation.swift
//  bankApp
//
//  Created by Byron Lester on 16/5/2024.
//

import Foundation


struct InputValidation {
    
    static func isValidMoneyAmount(_ amountString: String) -> Bool {
        let pattern = #"^\d+(\.\d{1,2})?$"# // Regular expression pattern to match valid money amounts
        guard let regex = try? NSRegularExpression(pattern: pattern) else { // Create regular expression object
            return false
        }
        let range = NSRange(location: 0, length: amountString.utf16.count)
        return regex.firstMatch(in: amountString, options: [], range: range) != nil
    }
}
