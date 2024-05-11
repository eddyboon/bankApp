
//  ProfileView.swift
//  Profile Bank App
//
//  Created by Yanisa Phadee on 3/5/2024.
//

import SwiftUI
import _PhotosUI_SwiftUI
import Firebase
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @StateObject var profileViewModel = ProfileViewModel()
    @State private var isProfileSaved = false
    //@State private var isProfileUpdated = false
    
    
    var body: some View {
        VStack {
            // (viewModel.isLoggedIn) {
                // Profile circle
                VStack {
                    ZStack(alignment: .topTrailing) {
                        
                        PhotosPicker(selection: $profileViewModel.selectedItem) {
                            if let image = profileViewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(user: viewModel.currentUser)
                                    .background (
                                        Circle()
                                            .fill(Color(.systemGray6))
                                            .frame(width: 128, height: 128)
                                            .shadow(radius: 10)
                                    )
                            }
                        }
                        
                        Image(systemName: "pencil")
                            .imageScale(.small)
                            .foregroundStyle(.gray)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 32, height: 32)
                            )
                            .offset(x: -8, y: 10)
                    }
                    .padding()
                    
                    if profileViewModel.shouldShowUpdateButton() {
                        Button(action: {
                            Task {
                                try await profileViewModel.updateUserData()
                                //isProfileUpdated = true
                            }
                        }) {
                            Text("Save profile picture")
                                .foregroundColor(.blue)
                                .font(.subheadline)
                        }
                    }
                    
//                    if isProfileSaved {
//                        Text("Successfully saved")
//                            .foregroundColor(.green)
//                    }

                    
                    // Name
                    Text(viewModel.currentUser?.name ?? "")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                }
                .padding(.top, 10) // Add padding to move the profile circle to the top
                .padding(.bottom, 30)
                
                // Spacer between profile and list
                Spacer()
                
                VStack(alignment: .leading) {
                    Section {
                        NavigationLink {
                            ChangeNameView()
                            //print("Change Name")
                        }label: {
                            ProfileRowView(imageName: "person.fill", title: "Change Name", tintColor: .blue, showChevron: true)
                        }
                    }
                    
                    Spacer().frame(height: 25)
                    
//                    Section {
//                        NavigationLink {
//                            ChangeEmailView()
//                        }label: {
//                            ProfileRowView(imageName: "envelope.fill", title: "Change Email", tintColor: .blue, showChevron: true)
//                        }
//                    }
                    
                    Spacer().frame(height: 25)
                    
                    Section {
                        NavigationLink {
                            ChangeNumberView()
                        }label: {
                            ProfileRowView(imageName: "phone.fill", title: "Change Mobile Number", tintColor: .blue, showChevron: true)
                        }
                    }
                    
                    Spacer().frame(height: 25)
                    
                    Section {
                        NavigationLink {
                            ChangePasswordView()
                        }label: {
                            ProfileRowView(imageName: "lock.fill", title: "Change Password", tintColor: .blue, showChevron: true)
                        }
                    }
                    
                    Spacer().frame(height: 25)
                    Section {
                        Button {
                            viewModel.signOut()
                        } label: {
                            ProfileRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red, showChevron: false)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    
    }

             
    
    
#Preview {
    ProfileView()
}


