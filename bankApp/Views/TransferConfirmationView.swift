//
//  TransferConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct TransferConfirmationView: View {
    
    @Binding var showFullscreenCover: Bool // Flag that notifies previous when fullscreen cover should be dismissed
    @Binding var transactionDismissed: Bool
    @StateObject var viewModel: TransferConfirmationViewModel
    
    init(transferAmount: Decimal, transferRecipientName: String, transactionDismissed: Binding<Bool>, showFullscreenCover: Binding<Bool> ) {
        _viewModel = StateObject(wrappedValue: TransferConfirmationViewModel(transferAmount: transferAmount, transferRecipientName: transferRecipientName))
        _transactionDismissed = transactionDismissed
        _showFullscreenCover = showFullscreenCover
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("✅")
                    .font(.largeTitle)
                Text("\nTransferred\n$\(viewModel.transferAmount) to \(viewModel.transferRecipientName) !")
                    .font(.largeTitle)
                    .bold()
                    .padding(10)
            }
            
            Button {
                showFullscreenCover = false
                transactionDismissed = true
            } label: {
                Text("OK")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                    .foregroundColor(.white)
            }
        }
        
    }
}

#Preview {
    TransferConfirmationView(transferAmount: 50, transferRecipientName: "Geoff", transactionDismissed: .constant(false), showFullscreenCover: .constant(true))
}
