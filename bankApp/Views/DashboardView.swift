//
//  DashBoardView.swift
//  bankApp
//
//  Created by Byron Lester on 30/4/24.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var viewModel: DashboardViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationController: NavigationController
    @Environment(\.dismiss) var dismiss
    
    init() {
        _viewModel = StateObject(wrappedValue: DashboardViewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                
                Image("eth-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .onTapGesture {
                        navigationController.currentTab = NavigationController.Tab.dashboard
                    }
                Text("Ether-Bank")
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    Button("Profile") {
                        
                    }
                    
                    Button("Signout") {
                        authViewModel.signOut()
                        dismiss()
                    }


                } label: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
            }
            .padding()
            
            
            
            TabView(selection: $navigationController.currentTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(NavigationController.Tab.dashboard)
                PayView()
                    .tabItem {
                        Label("Pay", systemImage: "dollarsign.circle.fill")
                    }
                    .tag(NavigationController.Tab.pay)
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
            .environmentObject(AuthViewModel())
            .environmentObject(NavigationController())
    }
}
