//
//  ChangeNameView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//


import SwiftUI

struct ChangePasswordView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    
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
                // Current password Field
                ZStack(alignment: .trailing) {
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecuredField: true)
                    }
                
                //new password
                ZStack(alignment: .trailing) {
                    InputView(text: $password, title: "New Password", placeholder: "Enter new password", isSecuredField: true)
                    
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
                
                // Confirm new password field
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword, title: "Confirm New Password", placeholder: "Re-Enter your new password", isSecuredField: true)
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
            Spacer()
        }
        .padding(.horizontal, 30)

                    
                    
        
        
        
        
        
        
                    
                //}
                Spacer()
                
                Button("Save") {
                    Task {
                     //to do updatePassword
                        dismiss()
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



