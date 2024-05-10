//
//  AuthViewModel.swift
//  bankApp
//
//  Created by Edward Ong on 1/5/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticateionFormProtocol {
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var failedLogin: Bool = false
    @Published var currentUser: User?
    
    
    init() {
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUser()
            isLoggedIn = true
        } catch {
            print("Failed to log in user")
            failedLogin = true
        }
    }
    
    func createUser(withEmail email: String, password: String, name: String, phoneNumber: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, name: name, email: email, phoneNumber: phoneNumber, balance: 0.00, birthday: Date())
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            isLoggedIn = true;
            
        } catch {
            print("Failed to create user")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            isLoggedIn = false
        } catch {
            print("Failed to log user out")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func checkString(string: String) -> Bool {
        let digits = CharacterSet.decimalDigits
        let stringSet = CharacterSet(charactersIn: string)
        
        return digits.isSuperset(of: stringSet)
    }
    
    
    
    func updateProfile(email: String, phoneNumber: String, birthday: Date) async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userRef = Firestore.firestore().collection("users").document(currentUser.uid)
        
        try await userRef.updateData([
            "email": email,
            "phoneNumber": phoneNumber,
            "birthday": birthday // Include birthday date in the update
        ])
        
        // Update local data
        if var currentUser = self.currentUser {
            currentUser.email = email
            currentUser.phoneNumber = phoneNumber
            currentUser.birthday = birthday
            self.currentUser = currentUser // Update the currentUser property
        }
    }


    

    
}
