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
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: DepositViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DepositViewModel())
    }
    
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
                TextField("", value: $viewModel.depositAmount, format: .number)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
            HStack(spacing: 20) {
                ForEach(viewModel.depositSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.depositAmount = suggestion
                    }) {
                        Text("\(suggestion)")
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
            }
            Button(action: {
                viewModel.depositMoney(depositAmount: viewModel.depositAmount, user: authViewModel.currentUser)
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
                DepositConfirmationView(depositAmount: viewModel.depositAmount, showFullscreenCover: $viewModel.showDepositConfirmationView)
            }
        }
    }
}



#Preview {
    DepositView()
        .environmentObject(AuthViewModel())
}
