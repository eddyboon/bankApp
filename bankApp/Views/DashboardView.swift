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
            
            // Header logo
            HStack {
                
                Image("eth-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .onTapGesture {
                        navigationController.currentTab = NavigationController.Tab.home
                    }
                Text("Ether-Bank")
                    .font(.headline)
                
                Spacer()
                
                // Profile menu
                Menu {
                    Button("Profile") {
                        navigationController.path.append(NavigationController.AppScreen.profile)
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
            
            
            // Tabview to transition between homeview and payview screens
            TabView(selection: $navigationController.currentTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(NavigationController.Tab.home)
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
