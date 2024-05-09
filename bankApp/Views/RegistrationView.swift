//
//  RegistrationView.swift
//  bankApp
//
//  Created by Edward Ong on 1/5/24.
//

import SwiftUI

struct RegistrationView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var name: String = ""
    @State var phoneNumber: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if (authViewModel.isLoggedIn) {
            DashboardView(viewModel: DashboardViewModel(), authViewModel: authViewModel, payViewModel: PayViewModel())
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
                    
                    // Email Field
                    ZStack(alignment: .trailing) {
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                        
                        if (!email.isEmpty) {
                            // check for constraints
                            if (!email.isEmpty && email.contains(".com") && email.contains("@")) {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                
                    // Name Field
                    ZStack(alignment: .trailing) {
                        InputView(text: $name, title: "Name", placeholder: "Enter your name")
                            .textInputAutocapitalization(.sentences)
                        
                        if (!name.isEmpty) {
                            // check for constraints
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }
                    }
                    
                    // Phone Number Field
                    ZStack(alignment: .trailing) {
                        InputView(text: $phoneNumber, title: "Phone Number", placeholder: "Enter your phone number")
                            .keyboardType(.numberPad)
                        
                        if (!phoneNumber.isEmpty) {
                            // check for constraints
                            if (phoneNumber.prefix(2) == "04" && phoneNumber.count == 10 && authViewModel.checkString(string: phoneNumber) == true) {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                    
                    // Password Field
                    ZStack(alignment: .trailing) {
                        InputView(text: $password, title: "Password", placeholder: "Enter a password", isSecuredField: true)
                        
                        if (!password.isEmpty) {
                            // check for constraints
                            if (password.count > 5) {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                    // Confirm password field
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Re-Enter your password", isSecuredField: true)
                        if (!password.isEmpty && !confirmPassword.isEmpty) {
                            // check for constraints
                            if (password == confirmPassword) {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Sign up button
                Button {
                    // Perform sign up button
                    Task {
                        try await authViewModel.createUser(withEmail: email, password: password, name: name, phoneNumber: phoneNumber)
                    }
                    
                } label: {
                    HStack {
                        Text("Sign Up")
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
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

// Form validation protocol to make sure login info is valid
extension RegistrationView: AuthenticateionFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains(".com") && email.contains("@") && !password.isEmpty && password.count > 5 && !name.isEmpty && confirmPassword == password && phoneNumber.prefix(2) == "04" && phoneNumber.count == 10 && authViewModel.checkString(string: phoneNumber) == true
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
    }
}
