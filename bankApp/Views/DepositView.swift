//
//  DepositView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

import SwiftUI
import Combine

struct DepositView: View {
    @StateObject var viewModel: DepositViewModel
    @State var depositAmount: Decimal = 0
    let depositSuggestions: [Decimal] = [10, 50, 100].map { Decimal($0) }
    var payViewModel: PayViewModel
    var depositConfirmationViewModel: DepositConfirmationViewModel
    var authViewModel: AuthViewModel
    var dashboardViewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            Text("Deposit")
                .font(.largeTitle)
                .bold()
                .padding(60)
            Text("Amount to add")
                .padding(.top)
            HStack {
                Text("$")
                TextField("", value: $depositAmount, format: .number)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
            HStack(spacing: 20) {
                ForEach(depositSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        depositAmount = suggestion
                    }) {
                        Text("\(suggestion)")
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
            }
            Button(action: {
                viewModel.depositMoney(depositAmount: depositAmount)
                viewModel.showDepositConfirmationView = true
            }) {
                Text("Submit")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .frame(width: 250, height: 50)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                    .foregroundColor(.white)
            }
            .fullScreenCover(isPresented: $viewModel.showDepositConfirmationView) {
                DepositConfirmationView(viewModel: depositConfirmationViewModel, authViewModel: authViewModel, payViewModel: payViewModel, depositAmount: depositAmount, dashboardViewModel: dashboardViewModel)
            }
        }
    }
}



#Preview {
    DepositView(viewModel: DepositViewModel(depositAmount: 50, showDepositConfirmationView: false, authViewModel: AuthViewModel()), payViewModel: PayViewModel(), depositConfirmationViewModel: DepositConfirmationViewModel(), authViewModel: AuthViewModel(), dashboardViewModel: DashboardViewModel())
}
