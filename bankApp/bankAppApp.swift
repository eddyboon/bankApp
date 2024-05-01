//
//  bankAppApp.swift
//  bankApp
//
//  Created by Edward Ong on 30/4/24.
//

import SwiftUI
import Firebase

@main
struct bankAppApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}
