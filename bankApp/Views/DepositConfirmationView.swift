//
//  DepositConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct DepositConfirmationView: View {
    @StateObject var viewModel: DepositConfirmationViewModel
    var authViewModel: AuthViewModel
    var payViewModel: PayViewModel
    var depositAmount: Decimal
    var dashboardViewModel: DashboardViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("✅")
                        .font(.largeTitle)
                    Text("\nDeposited\n$\(depositAmount) !")
                        .font(.largeTitle)
                        .bold()
                        .padding(10)
                }
                NavigationLink(
                    destination: DashboardView(viewModel: DashboardViewModel(), authViewModel: authViewModel, payViewModel: payViewModel),
                    label: {
                        Text("OK")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                            .foregroundColor(.white)
                    })
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    DepositConfirmationView(viewModel: DepositConfirmationViewModel(), authViewModel: AuthViewModel(), payViewModel: PayViewModel(), depositAmount: 50, dashboardViewModel: DashboardViewModel())
}
