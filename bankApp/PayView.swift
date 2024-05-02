//
//  PayView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct PayView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                        Text("Would you like to")
                            .font(.title)
                    NavigationLink(
                        destination: DepositView(viewModel: DepositViewModel()),
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
                        destination: TransferView(viewModel: TransferViewModel()),
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
    PayView()
}
