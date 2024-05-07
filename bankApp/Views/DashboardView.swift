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
    
    init() {
        _viewModel = StateObject(wrappedValue: DashboardViewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                
                Spacer()
                
                Menu {
                    Button("Profile") {
                        
                    }
                    Button("Sign out") {
                        authViewModel.isLoggedIn = false
                    }

                } label: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
            }
            .padding()
            
            
            
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
        .onTapGesture {
            viewModel.showDropdown = false
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
}
