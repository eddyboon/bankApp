    //
    //  HomeViewModel.swift
    //  bankApp
    //
    //  Created by Byron Lester on 2/5/2024.
    //

    import Foundation
    import Firebase
    import FirebaseFirestoreSwift


    class HomeViewModel: ObservableObject {
        @Published var user = User.MOCK_USER
        
        let db = Firestore.firestore()
        
        func retrieveUser() {
            
        }
    }
