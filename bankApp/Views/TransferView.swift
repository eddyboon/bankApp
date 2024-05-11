//
//  TransferView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct TransferView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: TransferViewModel
    @Environment(\.dismiss) var dismiss
    
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
                .onChange(of: viewModel.recipientNumber) {
                    viewModel.ensureNumberFormat()
                }
            Button {
                
            } label: {
                Text("Check")
            }

            
            Text("Amount to transfer")
                .padding(.top)
            HStack {
                Text("$")
                    .padding(.trailing, 5)
                    
                TextField("", value: $viewModel.transferAmount, format: .number)
                    .padding(.trailing, 10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.transferAmount) {
                        
                        viewModel.validateAmount()
                    }
            }
            // Value Suggestions
            HStack(spacing: 20) {
                ForEach(viewModel.transferSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.transferAmount = Decimal(suggestion)
                    }) {
                        Text("\(suggestion)")
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
            }
            if(!viewModel.undergoingNetworkRequests) {
                Button(action: {
                    Task {
                        await viewModel.transferMoney(authViewModel: authViewModel)
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
                .disabled(!viewModel.validAmount) // Disable the pay submit if the recipient or amount are invalid
            }
            else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
            
            Text("Transferring to \(viewModel.transferRecipient?.name ?? "undefined")")
                .opacity(viewModel.validRecipient ? 1.0 : 0)
            /*
            Text("Recipient not found")
                .opacity(!viewModel.validRecipient && viewModel.transferRecipient.count == 10 ? 1.0 : 0) */
        }
        .fullScreenCover(isPresented: $viewModel.showTransferConfirmationView) {
            TransferConfirmationView(transferAmount: viewModel.transferAmount, transferRecipientName: viewModel.transferRecipient?.name ?? "{Unknown recipient}", transactionDismissed: $viewModel.transactionDismissed, showFullscreenCover: $viewModel.showTransferConfirmationView)
        }
        .onReceive(viewModel.$transactionDismissed) { isDismissed in
            if isDismissed {
                navigationController.currentTab = NavigationController.Tab.dashboard
                dismiss()
            }
        }
    }
}

#Preview {
    TransferView()
        .environmentObject(AuthViewModel())
}
