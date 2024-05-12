//
//  PayView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct PayView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: PayViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: PayViewModel())
    }
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 20) {
                    Text("Would you like to")
                        .font(.title)
                NavigationLink(
                    destination: DepositView(),
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
                    destination: TransferView(),
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

#Preview {
    PayView()
        .environmentObject(AuthViewModel())
}
