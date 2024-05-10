//
//  TransferView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct TransferView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: TransferViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: TransferViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Transfer")
                .font(.largeTitle)
                .bold()
                .padding(60)
            Text("Recipient's phone number")
                .padding(.top)
            TextField("", text: $viewModel.recipientNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 250, height: 50)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                /*.onChange(of: $viewModel.recipientNumber) { newValue in
                    Task {
                        await viewModel.validateRecipient()
                    }
                    
                } */
            Text("Amount to transfer")
                .padding(.top)
            HStack {
                Text("$")
                TextField("", text: $viewModel.transferAmountString)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 50)
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
            Button(action: {
                Task {
                    await viewModel.transferMoney(transferAmount: viewModel.transferAmount, user: authViewModel.currentUser)
                }
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
            .opacity(viewModel.validAmount ? 1.0 : 0.5) // Darken the submit button if it is disabled, so the user knows their inputs are not valid yet
            .disabled(!viewModel.validAmount) // Disable the play submit if the recipient or amount are invalid
            .fullScreenCover(isPresented: $viewModel.showTransferConfirmationView) {
                TransferConfirmationView(transferAmount: viewModel.transferAmount, transferRecipientName: viewModel.transferRecipient?.name ?? "{Unknown recipient}")
            }
            Text("Transferring to \(viewModel.transferRecipient)")
                .opacity(viewModel.validRecipient ? 1.0 : 0)
            /*
            Text("Recipient not found")
                .opacity(!viewModel.validRecipient && viewModel.transferRecipient.count == 10 ? 1.0 : 0) */
        }
    }
}

#Preview {
    TransferView()
        .environmentObject(AuthViewModel())
}
