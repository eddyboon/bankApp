//
//  TransactionsView.swift
//  bankApp
//
//  Created by Byron Lester on 6/5/2024.
//

import Foundation
import SwiftUI


struct TransactionsView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: TransactionsViewModel
    
    init(transactions: [Transaction]) {
        _viewModel = StateObject(wrappedValue: TransactionsViewModel(transactions: transactions))
    }
    
    var body: some View {
        VStack {
            // Headinh
            Text("All Transactions")
                .font(.title)
                .padding()
            // Search field
            HStack {
                Text("Search:")
                    .padding(.trailing, 10)
                TextField("Filter by name, value or date", text: $viewModel.filterText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 14))
            }
            .padding()
           

            // Displays list of transactions
            ScrollView {
                if(viewModel.filteredTransactions.count == 0) {
                    Text("No transactions to show.")
                        .font(.headline)
                        .padding()
                } else {
                    // Loop through the filtered transaction list utilising the TransactionRowView component
                    ForEach(viewModel.filteredTransactions) { transaction in
                        TransactionRowView(transactionModel: transaction)
                    }
                }
            }
            // Refresh transactions of Scrollview pull down action
            .refreshable {
                viewModel.filterText = ""
                await viewModel.refreshTransactions(authViewModel: authViewModel)
            }
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

#Preview {
    TransactionsView(transactions: Transaction.Mock_Transactions)
}
