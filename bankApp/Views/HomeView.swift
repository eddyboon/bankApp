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
    
    let transactions: [Transaction] = Transaction.Mock_Transactions
    
  
    var body: some View {
        VStack(alignment: .leading) {
            if let userName = authViewModel.currentUser?.name {
                Text("Welcome \(userName),")
                    .font(.title)
                    .padding()
            }
            else {
                Text("Welcome {unauthorised},")
                    .font(.title)
                    .padding()
            }
            HStack {
                Text("Balance: ")
                    .font(.title2)
                    .padding()
                Text("AUD $4000")
                    .font(.headline)
            }
            
            VStack{
                   HStack{
                       Text("Latest Transactions")
                           .font(.title2)
                           .fontWeight(.bold)
                           .foregroundColor(.black)
                       Spacer()
                       Button{
                           
                       } label: {
                           Image(systemName: "arrow.up.right")
                               .resizable()
                               .frame(width: 17, height: 17)
                               .foregroundColor(.black)
                       }
                   }
                   .padding(.horizontal)
                   .padding(.trailing, 15)
                   .padding(.top, 30)
                   
                   LazyVStack (spacing: 25){
                       ForEach(transactions) { transaction in
                           TransactionRowView(transactionModel: transaction)
                       }
                   }.padding(.vertical,10)
                       .background(Color.white)
               }
            .background(.white)
            .cornerRadius(15)
            .padding()
            .shadow(color: Color.black.opacity(0.1), radius: 15, x: 5, y: 5)
            
            Button {
                
            } label: {
                Text("Add transaction test")
            }
            .padding(.horizontal)

        }
        
       }
    }

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
