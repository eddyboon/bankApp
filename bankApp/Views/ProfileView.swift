//
//  ProfileView.swift
//  Profile Bank App
//
//  Created by Yanisa Phadee on 3/5/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showEditProfile = false
    
    
    var body: some View {
       if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 5 ) {
                            Text(user.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                        }
                        Button {
                            showEditProfile.toggle()
                        }label: {
                            Text("Edit Profile")
                                .font(.subheadline).bold()
                                .frame(width:120, height: 30)
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
                                .foregroundColor(.black)
                                .padding(.top, 4)
                        }

                    }
                }
                
                Section {
                    Button {
                        viewModel.signOut()
                    } label: {
                        ProfileRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                }
            }//end
            .sheet(isPresented: $showEditProfile, content: {
                EditProfileView()
                })
       }
    }
}

#Preview {
    ProfileView()
}

