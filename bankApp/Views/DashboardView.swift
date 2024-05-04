//
//  DashBoardView.swift
//  bankApp
//
//  Created by Byron Lester on 30/4/24.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var viewModel = DashboardViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Button {
                authViewModel.isLoggedIn = false
            } label: {
                Text("Sign out")
                    .padding()
            }

            
            TabView(selection: $viewModel.selection ) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                PayView()
                    .tabItem {
                        Label("Pay", systemImage: "dollarsign.circle.fill")
                    }
                
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
}
