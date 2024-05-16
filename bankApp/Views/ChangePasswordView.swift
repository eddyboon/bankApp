//
//  ChangeNameView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//


import SwiftUI

struct ChangePasswordView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ChangePasswordViewModel

    init() {
    _viewModel = StateObject(wrappedValue: ChangePasswordViewModel())
        
    }
    
    var body: some View {
        //header
        VStack {
            Spacer().frame(height: 20) // Add a spacer to adjust the top space
            
            HStack {
                Text("Change Password")
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
                
                //new password
                ZStack(alignment: .trailing) {
                    InputView(text: $viewModel.password, title: "New Password", placeholder: "Enter new password", isSecuredField: true)
                    
                    if (!viewModel.password.isEmpty) {
                        // check for constraints
                        if (viewModel.password.count > 5) {
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
                
                // Confirm new password field
                ZStack(alignment: .trailing) {
                    InputView(text: $viewModel.confirmPassword, title: "Confirm New Password", placeholder: "Re-Enter your new password", isSecuredField: true)
                    if (!viewModel.password.isEmpty && !viewModel.confirmPassword.isEmpty) {
                        // check for constraints
                        if (viewModel.password == viewModel.confirmPassword) {
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

        if !viewModel.updateSuccessMessage.isEmpty {
            Text(viewModel.updateSuccessMessage)
                       .foregroundColor(.green)
                       .bold()
                       .padding(.bottom)
               }
                    
                //}
                Spacer()
                
                Button("Save") {
                    Task {
                        try await authViewModel.updatePassword(newPassword: viewModel.password)
                        viewModel.updateSuccessMessage = "Your password has been successfully updated."
                    }
                    
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
            //}
            Spacer()
            
        }
        
    }
        



#Preview {
    ChangePasswordView()
}



