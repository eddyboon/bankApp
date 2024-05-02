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
    @State var depositAmount: Int = 0
    let depositSuggestions = [10, 50, 100]
    
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
                DepositConfirmationView(viewModel: viewModel, depositAmount: depositAmount)
            }
        }
    }
}



#Preview {
    DepositView(viewModel: DepositViewModel())
}
