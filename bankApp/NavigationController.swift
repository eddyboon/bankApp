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
    
    enum Tab {
        case home
        case pay
    }
    
    @Published var path = NavigationPath()
    @Published var currentTab = Tab.home
}
