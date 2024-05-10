//
//  ChangeNameView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//


import SwiftUI

struct ChangeNameView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var name = ""
    @State private var selectedDate = Date()
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        //header
        VStack {
            Spacer().frame(height: 20) // Add a spacer to adjust the top space
            
            HStack {
                Text("Change Name")
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
                // name Field
                ZStack(alignment: .trailing) {
                    ZStack(alignment: .trailing) {
                        InputView(text: $name, title: "Name", placeholder: "Enter new name")
                            .textInputAutocapitalization(.sentences)
                        
                        if (!name.isEmpty) {
                            // check for constraints
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }
                    }
                }
            
            }
            Spacer()
        }
        .padding(.horizontal, 30)

                    
                    
        
            
            
                Button("Save") {
                    Task {
                        viewModel.updateName(name)
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
    ChangeNameView()
}


