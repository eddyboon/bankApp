//
//  DashboardViewModel.swift
//  bankApp
//
//  Created by Byron Lester on 3/5/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


class DashboardViewModel: ObservableObject {
    
    @Published var selection = tabs.home
    @Published var showDropdown: Bool = false
    
    enum tabs {
        case home
    }
    
}
