//
//  ChangeNameView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//


import SwiftUI

struct ChangeEmailView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var name = ""
    @State private var selectedDate = Date()
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmNewEmail = ""
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

                    
                    
        
                    
                //}
                Spacer()
                
                Button("Save") {
                    Task {
                        //to do: UpdateEmail
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
    ChangeEmailView()
}



