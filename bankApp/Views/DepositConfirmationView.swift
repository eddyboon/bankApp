//
//  DepositConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct DepositConfirmationView: View {
    @Binding var showFullscreenCover: Bool
    @StateObject var viewModel: DepositConfirmationViewModel
    
    init(depositAmount: Decimal, showFullscreenCover: Binding<Bool>, transactionDismissed: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: DepositConfirmationViewModel(depositAmount: depositAmount))
        self._showFullscreenCover = showFullscreenCover
    }
    
    var body: some View {
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
                .onTapGesture {
                    showFullscreenCover = false
                }
                .navigationBarBackButtonHidden(true)
            }
    }
}

#Preview {
    DepositConfirmationView(depositAmount: 50, showFullscreenCover: .constant(true), transactionDismissed: .constant(true))
        .environmentObject(AuthViewModel())
}
