//
//  NavigationController.swift
//  bankApp
//
//  Created by Byron Lester on 9/5/2024.
//

import Foundation
import SwiftUI

class NavigationController: ObservableObject {
    @Published var path = NavigationPath()
}
