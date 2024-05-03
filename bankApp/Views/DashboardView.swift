//
//  DashBoardView.swift
//  bankApp
//
//  Created by Byron Lester on 30/4/24.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var viewModel = DashboardViewModel()
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
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
}
