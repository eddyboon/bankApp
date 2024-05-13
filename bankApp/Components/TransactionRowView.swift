//
//  TransactionRowView.swift
//  bankApp
//
//  Created by Byron Lester on 2/5/2024.
//

import Foundation
import SwiftUI

struct TransactionRowView: View {
    
    var transactionModel: Transaction
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter
    }
    
    func displayBalance(amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        guard let formattedBalance = formatter.string(from: amount as NSDecimalNumber) else {
            return "Invalid balance"
        }
        
        return formattedBalance
    }
    
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading, spacing: 4){
                Text(transactionModel.name)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(dateFormatter.string(from: transactionModel.date))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            Spacer()
            if(transactionModel.type == "credit") {
                Text("+ $\(displayBalance(amount: transactionModel.amount))")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            else {
                Text("- $\(transactionModel.amount)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    TransactionRowView(transactionModel: Transaction.Mock_Transactions[0])
}
