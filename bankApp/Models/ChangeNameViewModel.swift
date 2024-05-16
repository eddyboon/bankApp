//
//  ChangeNameViewModel.swift
//  bankApp
//
//  Created by Byron Lester on 16/5/2024.
//

import Foundation

class ChangeNameViewModel: ObservableObject {
 
    @Published var name = ""
    @Published var presentPasswordVerification = false
    @Published var passwordAlert = ""
    @Published var isPasswordIncorrect = false
    @Published var presentIncorrectPasswordAlert = false
    @Published var updateSuccessMessage = ""
}
