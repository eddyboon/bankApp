//
//  TransferConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct TransferConfirmationView: View {
    @StateObject var viewModel: TransferViewModel
    var payViewModel: PayViewModel
    var transferAmount: Double
    var transferRecipient: String
    
    var body: some View {
        VStack {
            HStack {
                Text("✅")
                    .font(.largeTitle)
                Text("\nTransferred\n$\(transferAmount, specifier: payViewModel.getDoubleSpecifier(double: transferAmount))\nto \(transferRecipient) !")
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
    TransferConfirmationView(viewModel: TransferViewModel(), payViewModel: PayViewModel(), transferAmount: 100, transferRecipient: "User")
}
