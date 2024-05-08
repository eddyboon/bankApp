//
//  TransactionsView.swift
//  bankApp
//
//  Created by Byron Lester on 6/5/2024.
//

import Foundation
import SwiftUI


struct TransactionsView: View {
    
    @StateObject var viewModel: TransactionsViewModel
    
    init(transactions: [Transaction]) {
        _viewModel = StateObject(wrappedValue: TransactionsViewModel(transactions: transactions))
    }
    
    var body: some View {
        VStack {
            Text("All Transactions")
                .font(.title)
                .padding()
            
            HStack {
                Text("Search:")
                    .padding(.trailing, 10)
                TextField("Filter by name, value or date", text: $viewModel.filterText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 14))
            }
            .padding()
           

            
            ScrollView {
                if(viewModel.transactions.count == 0) {
                    Text("No transactions to show")
                } else {
                    // Force unwrap, change later
                    ForEach(viewModel.filteredTransactions) { transaction in
                        TransactionRowView(transactionModel: transaction)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

#Preview {
    TransactionsView(transactions: Transaction.Mock_Transactions)
}
