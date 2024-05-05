//
//  TransferView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct TransferView: View {
    @StateObject var viewModel: TransferViewModel
    @State var transferAmount: String = ""
    @State var transferRecipient: String = "04"
    let transferSuggestions = [10, 50, 100]
    @State var validRecipient: Bool = false
    @State var validAmount: Bool = false
    
    var body: some View {
        VStack {
            Text("Transfer")
                .font(.largeTitle)
                .bold()
                .padding(60)
            Text("Recipient's phone number")
                .padding(.top)
            TextField("", text: $transferRecipient)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 250, height: 50)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onChange(of: transferRecipient) {
                    if !transferRecipient.hasPrefix("04") {
                        transferRecipient = "04"
                    }
                    if transferRecipient.count > 10 {
                        transferRecipient = String(transferRecipient.prefix(10))
                    }
                    if(transferRecipient.count == 10) {
                        validRecipient = transferRecipient.allSatisfy(\.isNumber)
                    }
                    else {
                        validRecipient = false
                    }
                }
            Text("Amount to transfer")
                .padding(.top)
            HStack {
                Text("$")
                TextField("", text: $transferAmount)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onChange(of: transferAmount) {
                        if transferAmount.count > 10 {
                            transferAmount = String(transferAmount.prefix(10))
                        }
                        if let actualAmount = Double(transferAmount), actualAmount > 0 && transferAmount.count < 11 {
                            validAmount = true
                        }
                        else {
                            validAmount = false
                        }
                    }
            }
            HStack(spacing: 20) {
                ForEach(transferSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        transferAmount = String(suggestion)
                    }) {
                        Text("\(suggestion)")
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
            }
            Button(action: {
                viewModel.transferMoney(transferAmount: Double(transferAmount) ?? 0)
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
            .opacity(validRecipient && validAmount ? 1.0 : 0.5) // Darken the submit button if it is disabled, so the user knows their inputs are not valid yet
            .disabled(!validRecipient || !validAmount) // Disable the play submit if the recipient or amount are invalid
            .fullScreenCover(isPresented: $viewModel.showTransferConfirmationView) {
                TransferConfirmationView(viewModel: viewModel, transferAmount: Double(transferAmount) ?? 0, transferRecipient: transferRecipient)
            }
        }
    }
}

#Preview {
    TransferView(viewModel: TransferViewModel())
}
