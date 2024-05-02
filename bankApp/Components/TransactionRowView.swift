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
    
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading, spacing: 4){
                Text(transactionModel.name)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(transactionModel.date)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("- $\(transactionModel.value)")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }.padding(.horizontal)
        
    }
}

#Preview {
    TransactionRowView(transactionModel: Transaction.Mock_Transactions[0])
}
