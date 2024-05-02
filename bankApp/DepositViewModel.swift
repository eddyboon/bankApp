//
//  DepositViewModel.swift
//  bankApp
//
//  Created by Brandon Jury on 30/4/2024.
//

import Foundation

class DepositViewModel: ObservableObject {
    @Published var depositAmount: Int = 0
    @Published var showDepositConfirmationView: Bool = false
}
