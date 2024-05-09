//
//  EditProfileView.swift
//  Profile Bank App
//
//  Created by Yanisa Phadee on 5/5/2024.
//

import SwiftUI
import Firebase

struct EditProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var selectedDate = Date()
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @Environment(\.dismiss) var dismiss
    @State private var showError: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            if let user = viewModel.currentUser {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom,.horizontal])
                
                VStack(alignment: .leading) {
                    //name
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .fontWeight(.semibold)
                            Text(user.name)
                        }
                        
                        Spacer()
                        
                    }
                    Divider()
                    
                    //Date of Birth field
                    VStack(alignment: .leading) {
                        Text("Date of Birth")
                            .fontWeight(.semibold)
                        // DatePicker for selecting the date of birth
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .labelsHidden()
                            .background(Color.white) // Set the background color to white
                            .cornerRadius(8)
                        
                            .onAppear {
                            // Set selectedDate to the user's birthday when the view appears
                            selectedDate = user.birthday
                            }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Email Address")
                            .fontWeight(.semibold)
                        TextField("Enter Email...", text: $emailAddress)
                            .onAppear {
                            // Pre-populate email address from user data
                            emailAddress = user.email
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Phone Number")
                            .fontWeight(.semibold)
                        
                        TextField("Enter Phone Number...", text: $phoneNumber)
                            .keyboardType(.numberPad) // Optional: Restrict keyboard to numbers only
                            .onAppear {
                            // Pre-populate phone number from user data
                            phoneNumber = user.phoneNumber
                            }
                    }
                    
                    Divider()
                    
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
                
                if showError {
                    Text("Please complete all fields")
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
                
            }//end of zstack
                
            
        
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
                
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            try await viewModel.updateProfile(email: emailAddress, phoneNumber: phoneNumber, birthday: selectedDate)
                            dismiss()
                        }
                        
                        
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
                
                
            }
                
                
            }
        }
    }
    
    
}

#Preview {
    EditProfileView()
}

