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
                    let user = User(id: result.user.uid, name: name, email: email, phoneNumber: phoneNumber, balance: 0.00, birthday: Date(), profileImageUrl: "")
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
            }
        }
    }

    
    // Update user email
//    func updateEmail(newEmail: String) async throws {
//        do {
//            guard let user = Auth.auth().currentUser else {
//                print("User not authenticated")
//                return
//            }
//            
//            // Update email in Firestore
//            let db = Firestore.firestore()
//            let userRef = db.collection("users").document(user.uid)
//            try await userRef.setData(["email": newEmail], merge: true)
//            
//            // Update email
//            try await user.updateEmail(to: newEmail)
//            
//            print("Email updated successfully")
//        } catch {
//            // Handle errors
//            print("Failed to update email: \(error.localizedDescription)")
//            throw error
//        }
//    }
    
    // Update user email after reauthentication
//    func updateEmail(newEmail: String, currentPassword: String) async throws {
//        do {
//            guard let user = Auth.auth().currentUser else {
//                print("User not authenticated")
//                return
//            }
//            
//            // Reauthenticate user
//            let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
//            try await user.reauthenticate(with: credential)
//            
//            // Update email in Firestore
//            let db = Firestore.firestore()
//            let userRef = db.collection("users").document(user.uid)
//            try await userRef.setData(["email": newEmail], merge: true)
//            
//            // Update email
//            try await user.updateEmail(to: newEmail)
//            
//            print("Email updated successfully")
//        } catch {
//            // Handle errors
//            print("Failed to update email: \(error.localizedDescription)")
//            throw error
//        }
//    }
    
    
    func updateEmail(newEmail: String, currentPassword: String) async throws {
        do {
            guard let currentUser = Auth.auth().currentUser else {
                print("User not authenticated")
                return
            }
            
            
            //create a new user use ed method(), save new user in result, go into db
            
            //get older user, get old user data store it
            
            //copy data into new user .setdata, snapshot.data (fetch into snapshot)
            
            //jump to new user ref, instead of uid, .document.result.user.uid
            //setdata.snapshot.data
            
            // Reauthenticate user
            let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: currentPassword)
            try await currentUser.reauthenticate(with: credential)

            // Create a new user with the new email
            let result = try await Auth.auth().createUser(withEmail: newEmail, password: currentPassword) //save this in a variable, will get new UID for user -> store UID

            // Fetch user data from Firestore
            let uid = currentUser.uid
            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {
                print("Failed to fetch user data")
                return
            }
            guard let userData = try? snapshot.data(as: User.self) else {
                print("Failed to parse user data")
                return
            }

            // Print a message to indicate that the current user has been deleted
            print("Current user deleted successfully")

            // Update email in Firestore for the new user
            let db = Firestore.firestore()
            let newUserRef = db.collection("users").document(result.user.uid)
            //try await newUserRef.setData(["email": newEmail], merge: true)

            // Transfer user data to the new user
            try await newUserRef.setData(from: userData)

            print("Email updated successfully")
            
            try await currentUser.delete()
            
            
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
