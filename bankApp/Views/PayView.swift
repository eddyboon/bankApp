//
//  PayView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct PayView: View {
    @ObservedObject var authViewModel: AuthViewModel
    var viewModel: PayViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                        Text("Would you like to")
                            .font(.title)
                    NavigationLink(
                        destination: DepositView(viewModel: DepositViewModel(depositAmount: 0, showDepositConfirmationView: false, authViewModel: authViewModel), payViewModel: viewModel, depositConfirmationViewModel: DepositConfirmationViewModel(), authViewModel: authViewModel, dashboardViewModel: DashboardViewModel()),
                        label: {
                            Text("Deposit")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .frame(width: 300, height: 80)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding()
                                .foregroundColor(.white)
                        })
                    Text("or")
                        .font(.title)
                    NavigationLink(
                        destination: TransferView(viewModel: TransferViewModel(transferAmount: 0, showTransferConfirmationView: false, authViewModel: authViewModel), payViewModel: viewModel, authViewModel: authViewModel),
                        label: {
                            Text("Transfer")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .frame(width: 300, height: 80)
                                .background(Color.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding()
                                .foregroundColor(.white)
                        })
                                        
                }
            }
        }
    }
}

#Preview {
    PayView(authViewModel: AuthViewModel(), viewModel: PayViewModel())
}
