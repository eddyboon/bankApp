//
//  TransferView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct TransferView: View {
    @StateObject var viewModel: TransferViewModel
    var payViewModel: PayViewModel
    var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Transfer")
                .font(.largeTitle)
                .bold()
                .padding(30)
            ZStack {
                Text("Transferring to \(viewModel.transferRecipientName) ✅")
                    .opacity(viewModel.validRecipient && viewModel.recipientFound ? 1.0 : 0)
                    .fontWeight(.bold)
                Text("Recipient not found ❌")
                    .opacity(viewModel.recipientNameChecked && !viewModel.recipientFound && viewModel.validRecipient && viewModel.recipientChecked  ? 1.0 : 0)
                    .fontWeight(.bold)
            }
            Text("Recipient's phone number")
                .padding(.top)
            ZStack {
                TextField("", text: $viewModel.transferRecipient)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 210, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.transferRecipient) {
                        if viewModel.transferRecipient.count < 10 {
                            viewModel.recipientFound = false
                            viewModel.recipientChecked = false
                        }
                        viewModel.validateRecipient()
                    }
                HStack {
                    Rectangle()
                        .frame(width: 280, height: 50)
                        .opacity(0)
                    Button(action: {
                        viewModel.recipientChecked = true
                        viewModel.recipientNameChecked = false
                        Task {
                            try await viewModel.transferRecipientName = viewModel.getRecipientName(phoneNumber: viewModel.transferRecipient)
                            viewModel.recipientNameChecked = true
                            if viewModel.transferRecipientName != "" {
                                viewModel.recipientFound = true
                            }
                            else {
                                viewModel.recipientFound = false
                            }
                        }
                    }) {
                        Text("Check")
                            .fontWeight(.semibold)
                            .padding()
                    }
                    .disabled(!viewModel.recipientChecked && !viewModel.recipientFound && viewModel.validRecipient ? false : true)
                    .opacity(!viewModel.recipientChecked && !viewModel.recipientFound && viewModel.validRecipient ? 1.0 : 0.3)
                }
            }
            Text("Amount to transfer")
                .padding(.top)
            ZStack {
                HStack {
                    Text("$")
                    Rectangle()
                        .frame(width: 240, height: 50)
                        .opacity(0)
                }
                TextField("", text: $viewModel.transferAmountString)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 240, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.transferAmountString) {
                        viewModel.validateAmount()
                    }
            }
            HStack(spacing: 20) {
                ForEach(viewModel.transferSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.transferAmountString = String(suggestion)
                    }) {
                        Text("\(suggestion)")
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
            }
            ZStack {
                Button(action: {
                    viewModel.transferMoney(transferAmount: viewModel.transferAmount, recipientPhoneNo: viewModel.transferRecipient)
                    viewModel.showTransferConfirmationView = true
                }) {
                    Text("Submit")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .frame(width: 250, height: 50)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .foregroundColor(.white)
                }
                .opacity({
                    if viewModel.validRecipient && viewModel.validAmount && viewModel.recipientFound && viewModel.currentBalance >= viewModel.transferAmount {
                        return 1.0
                    }
                    else if viewModel.currentBalance < viewModel.transferAmount {
                        return 0
                    }
                    else {
                        return 0.5
                    }
                }()) // Darken the submit button if it is disabled, so the user knows their inputs are not valid yet
                .disabled(!viewModel.validRecipient || !viewModel.validAmount || !viewModel.recipientFound || viewModel.currentBalance < viewModel.transferAmount) // Disable the submit button if the recipient or amount are invalid
                .fullScreenCover(isPresented: $viewModel.showTransferConfirmationView) {
                    TransferConfirmationView(viewModel: viewModel, payViewModel: payViewModel, authViewModel: authViewModel, transferAmount: viewModel.transferAmount, transferRecipientName: viewModel.transferRecipientName)
                }
                Text("Your balance is too low ($\(viewModel.currentBalance)) ❌")
                    .fontWeight(.semibold)
                    .padding()
                    .opacity(viewModel.currentBalance < viewModel.transferAmount ? 1.0 : 0)
            }
        }
    }
}

#Preview {
    TransferView(viewModel: TransferViewModel(transferAmount: 100, showTransferConfirmationView: false, authViewModel: AuthViewModel()), payViewModel: PayViewModel(), authViewModel: AuthViewModel())
}
