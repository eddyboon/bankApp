//
//  DepositConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct DepositConfirmationView: View {
    @StateObject var viewModel: DepositConfirmationViewModel
    
    init(depositAmount: Decimal) {
        _viewModel = StateObject(wrappedValue: DepositConfirmationViewModel(depositAmount: depositAmount))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("✅")
                        .font(.largeTitle)
                    Text("\nDeposited\n$\(viewModel.depositAmount) !")
                        .font(.largeTitle)
                        .bold()
                        .padding(10)
                }
                NavigationLink(
                    destination: DashboardView(),
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
    DepositConfirmationView(depositAmount: 50)
        .environmentObject(AuthViewModel())
}
