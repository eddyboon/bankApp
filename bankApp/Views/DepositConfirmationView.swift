//
//  DepositConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct DepositConfirmationView: View {
    @StateObject var viewModel: DepositConfirmationViewModel
    var payViewModel: PayViewModel
    var depositAmount: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("✅")
                    .font(.largeTitle)
                Text("\nDeposited\n$\(depositAmount, specifier: payViewModel.getDoubleSpecifier(double: depositAmount)) !")
                    .font(.largeTitle)
                    .bold()
                    .padding(10)
            }
//            NavigationLink(
//                destination: DashboardView(),
//                label: {
//                    Text("OK")
//                        .font(.title)
//                        .frame(maxWidth: .infinity)
//                        .frame(width: 300, height: 50)
//                        .background(Color.blue)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .padding()
//                        .foregroundColor(.white)
//                })
        }
        
    }
}

#Preview {
    DepositConfirmationView(viewModel: DepositConfirmationViewModel(), payViewModel: PayViewModel(), depositAmount: 100)
}
