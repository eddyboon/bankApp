//
//  ChangeNumberViewModel.swift
//  bankApp
//
//  Created by Byron Lester on 16/5/2024.
//

import Foundation

class ChangeNumberViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var updateSuccessMessage = ""
    @Published var presentPasswordVerification = false
    @Published var passwordAlert = ""
    @Published var isPasswordIncorrect = false
    @Published var presentIncorrectPasswordAlert = false
}
