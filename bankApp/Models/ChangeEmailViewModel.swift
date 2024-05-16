//
//  ChangeEmailViewModel.swift
//  bankApp
//
//  Created by Byron Lester on 16/5/2024.
//

import Foundation

class ChangeEmailViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var confirmNewEmail = ""
    @Published var presentPasswordVerification = false
    @Published var passwordAlert = ""
    @Published var isPasswordIncorrect = false
    @Published var presentIncorrectPasswordAlert = false
    @Published var updateSuccessMessage = ""
}
