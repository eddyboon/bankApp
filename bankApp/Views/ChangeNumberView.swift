//
//  ChangeNameView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//


import SwiftUI

struct ChangeNumberView: View {
    
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
                Text("Change Contact Number")
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
                // Number Field
                ZStack(alignment: .trailing) {
                    InputView(text: $phoneNumber, title: "Phone Number", placeholder: "Enter your phone number")
                        .keyboardType(.numberPad)
                    
                    if (!phoneNumber.isEmpty) {
                        // check for constraints
                        if (phoneNumber.prefix(2) == "04" && phoneNumber.count == 10 && viewModel.checkString(string: phoneNumber) == true) {
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
                        //to do: UpdateNumber
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
    ChangeNumberView()
}



