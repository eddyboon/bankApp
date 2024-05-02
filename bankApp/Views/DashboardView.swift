//
//  DashBoardView.swift
//  bankApp
//
//  Created by Byron Lester on 30/4/24.
//

import SwiftUI

struct DashboardView: View {
    
    // @State var selectedTab = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
            }
        }
    }
}

#Preview {
    DashboardView()
}
