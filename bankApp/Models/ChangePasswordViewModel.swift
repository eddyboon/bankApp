//
//  ChangePasswordViewModel.swift
//  bankApp
//
//  Created by Byron Lester on 16/5/2024.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {
    
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var presentPasswordVerification = false
    @Published var passwordAlert = ""
    @Published var isPasswordIncorrect = false
    @Published var presentIncorrectPasswordAlert = false
    @Published var updateSuccessMessage = ""
}
