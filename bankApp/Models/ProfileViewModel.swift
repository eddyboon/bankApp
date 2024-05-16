//
//  EditProfileViewModel.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//

import Foundation
import PhotosUI
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() }  }
    }
    

    @Published var profileImage: Image?
    
    private var uiImage: UIImage?
    
    @MainActor
    func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    @MainActor
    func updateProfileImage(authViewModel: AuthViewModel) async {
        guard var currentUser = authViewModel.currentUser else {
            print("Unauthenticated user")
            return
        }
        
        guard let image = self.uiImage else { return }
        guard let imageUrl = try? await ImageUploader.uploadImage(image) else { return }
        do {
            try await FirestoreManager.shared.updateUserProfileImage(withImageUrl: imageUrl)
            currentUser.profileImageUrl = imageUrl
        }
        catch {
            print("Network error")
        }
        
    }
    
    func popToRootView(navigationController: NavigationController) {
        while(navigationController.path.count > 0) {
            navigationController.path.removeLast()
        }
    }
    
}
