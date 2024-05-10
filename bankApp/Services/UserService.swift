//
//  UserService.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageUrl" : imageUrl
        ])
        self.currentUser?.profileImageUrl = imageUrl
    }
    
}
