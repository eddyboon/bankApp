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
                TextField("", text: $viewModel.depositAmountString)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.depositAmountString) {
                        viewModel.validateAmount()
                    }
            }
            HStack(spacing: 20) {
                ForEach(viewModel.depositSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.depositAmountString = suggestion.description
                    }) {
                        Text("\(suggestion)")
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
            }
            Button(action: {
                viewModel.depositMoney(depositAmount: viewModel.depositAmount)
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
                DepositConfirmationView(viewModel: DepositConfirmationViewModel(), authViewModel: authViewModel, payViewModel: payViewModel, depositAmount: viewModel.depositAmount, dashboardViewModel: dashboardViewModel)
            }
            .opacity(viewModel.validAmount ? 1.0 : 0) // Darken the submit button if it is disabled, so the user knows their input is not valid yet
            .disabled(!viewModel.validAmount) // Disable the submit button if the amount is invalid
        }
    }
}



#Preview {
    DepositView(viewModel: DepositViewModel(depositAmount: 50, showDepositConfirmationView: false, authViewModel: AuthViewModel()), payViewModel: PayViewModel(), depositConfirmationViewModel: DepositConfirmationViewModel(), authViewModel: AuthViewModel(), dashboardViewModel: DashboardViewModel())
}
