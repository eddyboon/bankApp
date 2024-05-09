//
//  DashBoardView.swift
//  bankApp
//
//  Created by Byron Lester on 30/4/24.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: DashboardViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    var payViewModel: PayViewModel
    
    init(viewModel: DashboardViewModel, authViewModel: AuthViewModel, payViewModel: PayViewModel) {
        self.viewModel = viewModel
        self.payViewModel = payViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                
                Spacer()
                
                Menu {
                    Button("Profile") {
                        
                    }
                    
                    NavigationLink {
                        LoginView().onAppear(perform: {
                            authViewModel.signOut()
                        }).navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Sign Out")
                    }
                    
                    
                } label: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
            }
            .padding()
            
            
            
            TabView() {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                PayView(authViewModel: authViewModel, viewModel: payViewModel)
                    .tabItem {
                        Label("Pay", systemImage: "dollarsign.circle.fill")
                    }
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView(viewModel: DashboardViewModel(), authViewModel: AuthViewModel(), payViewModel: PayViewModel())
            .environmentObject(AuthViewModel())
    }
}
