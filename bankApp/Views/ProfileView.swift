
//  ProfileView.swift
//  Profile Bank App
//
//  Created by Yanisa Phadee on 3/5/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    @State private var showEditProfile = false
    @StateObject var editViewModel = EditProfileViewModel()
    
    var body: some View {
        VStack {
            if let user = viewModel.currentUser {
                // Profile circle
                VStack {
                    Text(user.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 180)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                        .padding()
                    
                    // Name
                    Text(user.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4) // Add padding between the circle and the name
                    
                    // Edit Profile Button
                    Button {
                        showEditProfile.toggle()
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline).bold()
                            .frame(width: 120, height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
                            .foregroundColor(.black)
                            .padding(.bottom, 4)
                    }
                }
                .padding(.top) // Add padding to move the profile circle to the top
                
                
                // Spacer between profile and list
                Spacer()
                
                // List
                List {
                    Section {
                        Button {
                            print("Change Password")
                        }label: {
                            ProfileRowView(imageName: "lock.fill", title: "Change Password", tintColor: .red)
                            
                        }
                    }
                
                    Section {
                        Button {
                            viewModel.signOut()
                        } label: {
                            ProfileRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                        }
                    }
                    
                }//end of list
            }
        }
        .sheet(isPresented: $showEditProfile, content: {
            EditProfileView(editViewModel: EditProfileViewModel())
                
         })
        }
    }

    
    
#Preview {
    ProfileView()
}

