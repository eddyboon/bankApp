//
//  TempDashboardView.swift
//  bankApp
//
//  Created by Edward Ong on 2/5/24.
//

import SwiftUI

struct TempDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Hello, World! This is where the dashboard view will be")
            Text("This line should show")
            Text("Email: \(authViewModel.currentUser?.email ?? "errorEmail"), phone number: \(authViewModel.currentUser?.phoneNumber ?? "errorNumber")")
        }
        
    }
}

#Preview {
    NavigationStack {
        TempDashboardView()
    }
}
