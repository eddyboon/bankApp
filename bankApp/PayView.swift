//
//  PayView.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import SwiftUI

struct PayView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Deposit or transfer")
                    .font(.largeTitle)
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 300, height: 100)
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 300, height: 100)
                                    
            }
        }
    }
}

#Preview {
    PayView()
}
