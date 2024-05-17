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
            Spacer() // Push down
            // Title
            Text("Transfer")
                .font(.largeTitle)
                .bold()
                .padding(60)
            // Success status message if phone number is valid
            if(viewModel.validRecipient && !viewModel.userFetching && viewModel.checkButtonPressed) {
                Text("Transferring to \(viewModel.transferRecipient?.name ?? "undefined") ✅")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            // Error status message if phone number is invalid
            if(!viewModel.validRecipient && !viewModel.userFetching && viewModel.checkButtonPressed) {
                Text(viewModel.numberErrorMessage)
                    .fontWeight(.bold)
            }
            Text("Recipient's phone number")
                .padding(.top)
            // Recipient phone number textfield
            TextField("", text: $viewModel.recipientNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onChange(of: viewModel.recipientNumber) {
                    viewModel.ensurePhoneNumberFormat() // Verifies correct phone number format
                    if(viewModel.recipientNumber.count < 10) {
                        viewModel.checkButtonPressed = false
                    }
                }
                .padding(.horizontal, 50)
            // Flag for showing check button or progress view
            if(!viewModel.userFetching) {
                Button {
                    viewModel.userFetching = true
                    viewModel.checkButtonPressed = true
                    Task {
                        await viewModel.getRecipient(phoneNumber: viewModel.recipientNumber, senderPhoneNumber: authViewModel.currentUser?.phoneNumber ?? "0")
                    }
                } label: {
                    Text("Check")
                }
                // Disable button if input invalid or recipient invalid
                .disabled(!viewModel.validNumberInput || viewModel.validRecipient || viewModel.checkButtonPressed)
                .padding(.vertical, 5)
            }
            else {
                ProgressView()
            }
            

            
            Text("Amount to transfer ($)")
                .padding(.top)
            // Transfer amount field
            TextField("", text: $viewModel.transferAmountString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .onChange(of: viewModel.transferAmountString) {
                    // Validates correct currency number format
                    viewModel.validateAmount(authViewModel: authViewModel)
                }
                .padding(.horizontal, 50)
            // Value Suggestions
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
            // Display error message depending on flag state
            if(!viewModel.errorMessage.isEmpty) {
                Text(viewModel.errorMessage)
                    .fontWeight(.semibold)
                    .padding()
            }
            // Show button or progress view depending on network request flag
            if(!viewModel.undergoingNetworkRequests) {
                Button(action: {
                    Task {
                        await viewModel.transferMoney(authViewModel: authViewModel)
                    }
                }) {
                    Text("Submit")
                        .font(.title2)
                        .frame(width: 250, height: 50)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .foregroundColor(.white)
                }
                .opacity(viewModel.validRecipient && viewModel.validAmount ? 1.0 : 0.5)
                .disabled(!viewModel.validAmount || !viewModel.validRecipient) // Disable the pay submit if the recipient or amount are invalid
            }
            else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
            Spacer()
        }
        // If transfer submission successful, show confirmation using fullscreen cover
        .fullScreenCover(isPresented: $viewModel.showTransferConfirmationView) {
            TransferConfirmationView(transferAmount: viewModel.transferAmount, transferRecipientName: viewModel.transferRecipient?.name ?? "{Unknown recipient}", transactionDismissed: $viewModel.transactionDismissed, showFullscreenCover: $viewModel.showTransferConfirmationView)
        }
        // If confirmation is dismissed, return to dashboard
        .onReceive(viewModel.$transactionDismissed) { isDismissed in
            if isDismissed {
                navigationController.currentTab = NavigationController.Tab.home
                dismiss()
            }
        }
        
    }
        
}

#Preview {
    TransferView()
        .environmentObject(AuthViewModel())
}
