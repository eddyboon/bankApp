//
//  ChangeNameView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//


import SwiftUI

struct ChangeEmailView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var emailAddress = ""
    @State private var password = ""
    @State private var confirmNewEmail = ""
    @State private var presentPasswordVerification = false
    @State private var passwordAlert = ""
    @State private var isPasswordIncorrect = false
    @State private var presentIncorrectPasswordAlert = false
    @State private var updateSuccessMessage = ""
    @Environment(\.dismiss) var dismiss
    
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
                    InputView(text: $emailAddress, title: "New Email Address", placeholder: "Enter new email")
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    if (!emailAddress.isEmpty) {
                        // check for constraints
                        if (!emailAddress.isEmpty && emailAddress.contains(".com") && emailAddress.contains("@")) {
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
            presentPasswordVerification = true
        }.alert("Enter Your Password", isPresented: $presentPasswordVerification, actions: {
            SecureField("Password", text: $passwordAlert)
            Button("Done", action: {
                Task {
                    do {
                        try await viewModel.verifyPassword(password: passwordAlert)
                    }catch {
                        // Password incorrect, show the incorrect password alert
                        presentPasswordVerification = false // Dismiss the first alert
                        presentIncorrectPasswordAlert = true
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {
                dismiss()
            })
            }, message: {
                Text("To ensure the security of your account, please enter your current password to proceed with making changes")
        })
        .alert("Incorrect Password, Please Try Again", isPresented: $presentIncorrectPasswordAlert, actions: {
                    Button("OK", action: {
                        // Dismiss the incorrect password alert and reset variables
                        presentIncorrectPasswordAlert = false
                        isPasswordIncorrect = false
                        passwordAlert = ""
                        // Show the password verification alert again
                        presentPasswordVerification = true
                    })
                })
        //end of alert
        
        //success message
        if !updateSuccessMessage.isEmpty {
                   Text(updateSuccessMessage)
                       .foregroundColor(.green)
                       .bold()
                       .padding(.bottom)
               }

                    
                    
        
                    
                //}
                Spacer()
                
                Button("Save") {
                    Task {
                        //to do: UpdateEmail
                        try await viewModel.updateEmail(newEmail: emailAddress)
                        updateSuccessMessage = "Verify new email for secure update."
                        //dismiss()
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
    ChangeEmailView()
}



