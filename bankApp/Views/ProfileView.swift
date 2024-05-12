
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
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationController: NavigationController
    
    @StateObject var viewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
   
    var body: some View {
        VStack {
            // Profile circle
            VStack {
                ZStack(alignment: .topTrailing) {
                    
                    PhotosPicker(selection: $viewModel.selectedItem) {
                        if let image = viewModel.profileImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width:128, height: 128)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        } else {
                            CircularProfileImageView(user: authViewModel.currentUser)
                                .background (
                                    Circle()
                                        .fill(Color(.systemGray6))
                                        .frame(width: 128, height: 128)
                                        .shadow(radius: 10)
                                )
                        }
                    }
                    .onChange(of: viewModel.profileImage) {
                        showAlert = true
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
 
                // Name
                Text(authViewModel.currentUser?.name ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                
            }
            
            .padding(.top, 10) // Add padding to move the profile circle to the top
            .padding(.bottom, 30)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Image Selected"), message: Text("Do you want to save this profile picture?"), primaryButton: .default(Text("Save")) {
                    Task {
                        try await viewModel.updateUserData()
                    }
                }, secondaryButton: .cancel())
            }
            
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
                    Section {
                        NavigationLink {
                            ChangeEmailView()
                        }label: {
                            ProfileRowView(imageName: "envelope.fill", title: "Change Email", tintColor: .blue, showChevron: true)
                        }
                    }
                
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
                        authViewModel.signOut()
                        viewModel.popToRootView(navigationController: navigationController)
                        
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


