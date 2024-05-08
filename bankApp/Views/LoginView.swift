//
//  ContentView.swift
//  bankApp
//
//  Created by Edward Ong on 30/4/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            if (authViewModel.isLoggedIn) {
                DashboardView()
            } else {
                VStack {
                    // Image or header
                    Image("eth-logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .padding(.vertical, 32)
                    // form Fields
                    VStack (spacing: 24) {
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        InputView(text: $password, title: "Password", placeholder: "Enter a password", isSecuredField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    // sign in button
                    Button {
                        // Perform sign in action
                        Task {
                            try await authViewModel.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("Sign In")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 24)
                    .alert("Failed to login. Try Again", isPresented: $authViewModel.failedLogin) {
                        Button("Ok", role: .cancel) {
                            authViewModel.failedLogin = false
                        }
                    }
                    
                    Spacer()
                    
                    // sign up button
                    NavigationLink {
                        RegistrationView().navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("Don't have an account?")
                            Text("Sign up")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        .font(.system(size: 14))
                    }
                    
                    // End of vstack
                }
            }
            
            // End of navview
        }
    }
}

// Form validation protocol to make sure login info is valid
extension LoginView: AuthenticateionFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
