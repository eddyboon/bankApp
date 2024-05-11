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
            let user = User(id: result.user.uid, name: name, email: email, phoneNumber: phoneNumber, balance: 0.00, birthday: Date(), profileImageUrl: "")
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
    
    

    //Updates name when user changes in profile
    func updateName(_ newName: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // Update Firestore
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        userRef.updateData(["name": newName]) { error in
            if let error = error {
                print("Error updating name: \(error)")
            } else {
                print("Name successfully updated")
            }
        }
    }

    
    //To Do:
    
    
    // Update Email
//    func updateEmail() {
//        let db = Firestore.firestore()
//        let userEmail = Auth.auth().currentUser?.email
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        if emailAddress.text != nil {
//            db.collection("users").document("\(uid)").updateData(["UserEmail": emailAddress.text!])
//            if emailAddress.text != userEmail {
//                currentUser?.updateEmail(to: emailAddress.text!) { error in
//                    if let error = error {
//                        print(error)
//                    }
//                }
//            }
//        }
//
//    }


    
    // Update Phone Number
    func updatePhoneNumber(_ newPhoneNumber: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard var user = try? document?.data(as: User.self) else {
                print("Failed to parse user document")
                return
            }
            
            user.phoneNumber = newPhoneNumber
            
            do {
                try Firestore.firestore().collection("users").document(uid).setData(from: user)
                print("Phone number updated successfully")
            } catch {
                print("Failed to update phone number: \(error.localizedDescription)")
            }
        }
    }


    
    
    // Update Password
    
//    func updatePassword() {
//        
//    }
//    
    
    func updatePassword(newPassword: String) async throws {
        do {
            // Update the password
            let user = Auth.auth().currentUser
            try await user?.updatePassword(to: newPassword)
            
            // Password updated successfully
            print("Password updated successfully")
        } catch {
            // Handle errors
            print("Failed to update password: \(error.localizedDescription)")
            throw error
        }
    }

    
    
    
    //verify user before allowing them to change profile credentials
    func verifyPassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
            // Password verification successful, user is reauthenticated
        } catch {
            //print("Incorrect Password: \(error.localizedDescription)")
            throw error
        }
    }

    
   
  







    

    
}
