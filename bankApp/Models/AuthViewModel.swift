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
    @Published var failedSignup: Bool = false
    @Published var emailAlreadyExist: Bool = false
    @Published var numberAlreadyExist: Bool = false
    @Published var signupLoading: Bool = false
    @Published var signinLoading: Bool = false
    @Published var currentUser: User?
    
    
    init() {
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            signinLoading = true
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUser()
            isLoggedIn = true
            signinLoading = false
        } catch {
            print("Failed to log in user")
            failedLogin = true
            signinLoading = false
        }
    }
    
    func createUser(withEmail email: String, password: String, name: String, phoneNumber: String) async throws {
        do {
            signupLoading = true
            // Check if phoneNumber exists
            let querySnapshot = try await Firestore.firestore().collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments()
            if (querySnapshot.isEmpty) {
                // Check if email is already in use
                let emailQuerySnapshot = try await Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments()
                if (emailQuerySnapshot.isEmpty) {
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    let user = User(id: result.user.uid, name: name, email: email, phoneNumber: phoneNumber, balance: 0.00)
                    let encodedUser = try Firestore.Encoder().encode(user)
                    try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
                    await fetchUser()
                    isLoggedIn = true;
                } else {
                    emailAlreadyExist = true
                }
            } else {
                numberAlreadyExist = true
            }
            signupLoading = false
        } catch {
            print("Failed to create user")
            failedSignup = true
            signupLoading = false
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

    func signOut() {
            do {
                try Auth.auth().signOut()
                self.currentUser = nil
                isLoggedIn = false
            } catch {
                print("Failed to log user out")
            }
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
                self.currentUser?.name = newName
            }
        }
    }

    
     //Update user email
    func updateEmail(newEmail: String) async throws {
        do {
            guard let user = Auth.auth().currentUser else {
                print("User not authenticated")
                return
            }
            //check if email exists in db
            let emailQuerySnapshot = try await Firestore.firestore().collection("users").whereField("email", isEqualTo: newEmail).getDocuments()
            
            if (emailQuerySnapshot.isEmpty) {
                // Update email in Firestore
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.uid)
                try await userRef.setData(["email": newEmail, "id": user.uid], merge: true)
                
                // Send email verification
                try await user.sendEmailVerification(beforeUpdatingEmail: newEmail)
                
                print("Email updated successfully")
            } else {
                emailAlreadyExist = true
            }
        } catch {
            // Handle errors
            print("Failed to update email: \(error.localizedDescription)")
            throw error
        }
    }

    


    
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
