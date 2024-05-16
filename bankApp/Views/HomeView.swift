//
//  HomeView.swift
//  bankApp
//
//  Created by Byron Lester on 2/5/2024.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: HomeViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel())
    }
  
    var body: some View {
        VStack(alignment: .leading) {
            // Display name of user
            if let userName = authViewModel.currentUser?.name {
                Text("Welcome \(userName),")
                    .font(.title)
                    .padding()
            }
            else {
                // If not logged in, displsy uuauthorised
                // In theory this code should never be read
                Text("Welcome {unauthorised},")
                    .font(.title)
                    .padding()
            }
            HStack {
                //  Display user balance
                Text("Balance: ")
                    .font(.title2)
                    .padding()
                if let balance = authViewModel.currentUser?.displayBalance() {
                    Text(balance)
                }
                else {
                    // If user resolves to nil, show unauthorised
                    Text("Unauthorised, no balance to show.")
                }
                
            }
            
            // Recent transactions card
            VStack{
                   HStack{
                       Text("Latest Transactions")
                           .font(.title2)
                           .fontWeight(.bold)
                           .foregroundColor(.black)
                       Spacer()
                       Button(action: {
                           
                       }) {
                           // All transactions button
                           NavigationLink(destination: TransactionsView(transactions: viewModel.transactions)) {
                               Image(systemName: "arrow.up.right")
                                   .resizable()
                                   .frame(width: 17, height: 17)
                                   .foregroundColor(.black)
                           }
                       }

                   }
                   .padding(.horizontal)
                   .padding(.trailing, 15)
                   .padding(.top, 30)
                   
                   LazyVStack (spacing: 25){
                       // Show loading circle if fetch is in process
                       if(viewModel.isLoadingTransactions) {
                           ProgressView()
                               .progressViewStyle(CircularProgressViewStyle())
                               .scaleEffect(1.5)
                       }
                       else {
                           if(viewModel.transactions.count == 0) {
                               Text("No transactions to show")
                           } else {
                               // Show only 7 most recent transactions.
                               ForEach(viewModel.transactions.prefix(6)) { transaction in
                                   TransactionRowView(transactionModel: transaction)
                               }
                           }
                       }
                       
                       
                       
                   }
                   .padding(.vertical,10)
                   .background(Color.white)
               } 
            .background(.white)
            .cornerRadius(15)
            .padding()
            .shadow(color: Color.black.opacity(0.1), radius: 15, x: 5, y: 5)
            
            // Push everything to top
            Spacer()

        } // End of root vstack
        // Fetch transactions when view is initialised
        .onAppear {
            Task {
                await viewModel.fetchTransactions(authViewModel: authViewModel)
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)

        
       }
    }

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
