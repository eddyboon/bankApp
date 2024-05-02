//
//  DepositConfirmationView.swift
//  bankApp
//
//  Created by Brandon Jury on 2/5/2024.
//

import SwiftUI

struct DepositConfirmationView: View {
    @StateObject var viewModel: DepositViewModel
    var depositAmount: Int
    
    var body: some View {
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
                destination: ContentView(),
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
        }
        
    }
}

#Preview {
    DepositConfirmationView(viewModel: DepositViewModel(), depositAmount: 100)
}
