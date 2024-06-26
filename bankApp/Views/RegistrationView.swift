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
    @EnvironmentObject var navigationController: NavigationController
    
    var body: some View {
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
            
            if (authViewModel.signupLoading) {
                // Show loading icon
                Spacer()
                    .frame(minHeight: 10, idealHeight: 25, maxHeight: 25)
                    .fixedSize()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                // Sign up button
                Button {
                    // Perform sign up button
                    Task {
                        try await authViewModel.createUser(withEmail: email, password: password, name: name, phoneNumber: phoneNumber)
                        if(authViewModel.isLoggedIn) {
                            navigationController.path.append(NavigationController.AppScreen.dashboard)
                        }
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
                .alert("Failed to Signup. Phone Number already exists.", isPresented: $authViewModel.numberAlreadyExist) {
                    Button("Ok", role: .cancel) {
                        authViewModel.numberAlreadyExist = false
                    }
                }
                .alert("Failed to Signup. An error occurred. Please try again.", isPresented: $authViewModel.failedSignup) {
                    Button("Ok", role: .cancel) {
                        authViewModel.failedSignup = false
                    }
                }
                .alert("Failed to Signup. Email already exists.", isPresented: $authViewModel.emailAlreadyExist) {
                    Button("Ok", role: .cancel) {
                        authViewModel.emailAlreadyExist = false
                    }
                }
            }
            
            Spacer()
            
            // Footer: if user wants to login instead of sign up
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

// Form validation protocol to make sure login info is valid
extension RegistrationView: AuthenticateionFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains(".com") && email.contains("@") && !password.isEmpty && password.count > 5 && !name.isEmpty && confirmPassword == password && phoneNumber.prefix(2) == "04" && phoneNumber.count == 10 && authViewModel.checkString(string: phoneNumber) == true
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel()) // Provide an instance of AuthViewModel to the preview
    }
}

   
