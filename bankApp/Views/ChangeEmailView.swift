//
//  ChangeNameView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//


import SwiftUI

struct ChangeEmailView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: ChangeEmailViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init() {
        _viewModel = StateObject(wrappedValue: ChangeEmailViewModel())
    }
    
    var body: some View {
        //header
        VStack {
            Spacer().frame(height: 20) // Add a spacer to adjust the top space
            
            HStack {
                Text("Change Email")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding(.leading, 30) // Add left padding to move closer to the left
                Spacer()
            }
            
            Rectangle()
                .frame(height: 1) // Adjust the height of the line as needed
                .foregroundColor(.gray)
                .padding(.horizontal, 30) // Add horizontal padding to prevent extending off the screen
        }
        
        VStack {
            Spacer()
            VStack (spacing: 24) {
                // Email Field
                ZStack(alignment: .trailing) {
                    InputView(text: $viewModel.emailAddress, title: "New Email Address", placeholder: "Enter new email")
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    if (!viewModel.emailAddress.isEmpty) {
                        // check for constraints
                        if (!viewModel.emailAddress.isEmpty && viewModel.emailAddress.contains(".com") && viewModel.emailAddress.contains("@")) {
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
            Spacer()
        }
        .padding(.horizontal, 30)
        
        //alert
        .onAppear() {
            viewModel.presentPasswordVerification = true
        }.alert("Enter Your Password", isPresented: $viewModel.presentPasswordVerification, actions: {
            SecureField("Password", text: $viewModel.passwordAlert)
            Button("Done", action: {
                Task {
                    do {
                        try await authViewModel.verifyPassword(password: viewModel.passwordAlert)
                    }catch {
                        // Password incorrect, show the incorrect password alert
                        viewModel.presentPasswordVerification = false // Dismiss the first alert
                        viewModel.presentIncorrectPasswordAlert = true
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {
                dismiss()
            })
            }, message: {
                Text("To ensure the security of your account, please enter your current password to proceed with making changes")
        })
        .alert("Incorrect Password, Please Try Again", isPresented: $viewModel.presentIncorrectPasswordAlert, actions: {
                    Button("OK", action: {
                        // Dismiss the incorrect password alert and reset variables
                        viewModel.presentIncorrectPasswordAlert = false
                        viewModel.isPasswordIncorrect = false
                        viewModel.passwordAlert = ""
                        // Show the password verification alert again
                        viewModel.presentPasswordVerification = true
                    })
                })
        //end of alert
        
        //success message
        if !viewModel.updateSuccessMessage.isEmpty {
            Text(viewModel.updateSuccessMessage)
                       .foregroundColor(.green)
                       .bold()
                       .padding(.bottom)
               }
                Spacer()
                
                Button("Save") {
                    Task {
                        //to do: UpdateEmail
                        try await authViewModel.updateEmail(newEmail: viewModel.emailAddress)
                        if !authViewModel.emailAlreadyExist {
                            viewModel.updateSuccessMessage = "Verify new email for secure update."
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
                .alert("Failed to Signup. Email already exists.", isPresented: $authViewModel.emailAlreadyExist) {
                    Button("Ok", role: .cancel) {
                        authViewModel.emailAlreadyExist = false
                    }
                }
            Spacer()
            
        }
        
    }
        



#Preview {
    ChangeEmailView()
        .environmentObject(AuthViewModel())
}



