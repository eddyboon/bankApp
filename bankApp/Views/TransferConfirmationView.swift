//
//  TransferConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct TransferConfirmationView: View {
    
    @StateObject var viewModel: TransferConfirmationViewModel
    
    init(transferAmount: Decimal, transferRecipientName: String) {
        _viewModel = StateObject(wrappedValue: TransferConfirmationViewModel(transferAmount: transferAmount, transferRecipientName: transferRecipientName))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("✅")
                    .font(.largeTitle)
                Text("\nTransferred\n$\(viewModel.transferAmount) !")
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
    TransferConfirmationView(transferAmount: 50, transferRecipientName: "Geoff")
}
