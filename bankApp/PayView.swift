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
                VStack {
                        Text("Would you like to")
                            .font(.title)
                    NavigationLink(
                        destination: DepositView(),
                        label: {
                            Text("Deposit")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(width: 300, height: 80)
                                .background(Color.cyan)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding()
                                .foregroundColor(.white)
                        })
                    Text("or")
                        .font(.title)
                    NavigationLink(
                        destination: TransferView(),
                        label: {
                            Text("Transfer")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(width: 300, height: 80)
                                .background(Color.cyan)
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
