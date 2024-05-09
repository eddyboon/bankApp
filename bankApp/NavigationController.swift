//
//  NavigationController.swift
//  bankApp
//
//  Created by Byron Lester on 9/5/2024.
//

import Foundation
import SwiftUI

class NavigationController: ObservableObject {
    
    enum AppScreen: Hashable {
        case login
        case dashboard
        case pay
        case deposit
        case transfer
        case profile
    }
    
    @Published var path = NavigationPath()
}
