import SwiftUI
import Firebase

@main
struct bankAppApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var navigationController = NavigationController()
    
    init() {
        FirebaseApp.configure()
    }
    
    enum AppScreen: Hashable {
        case login
        case dashboard
        case pay
        case profile
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationController.path) {
                LoginView()
                    .onChange(of: authViewModel.isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            navigationController.path.append(AppScreen.dashboard)
                        }
                        else {
                            navigationController.path.removeLast()
                        }
                    }
                    .navigationDestination(for: AppScreen.self) { screen in
                        switch screen {
                        case .login:
                            LoginView()
                        case .dashboard:
                            DashboardView()
                                .navigationBarBackButtonHidden(true)
                        default:
                            LoginView()
                        }
                        
                    }
            }
            .environmentObject(authViewModel)
            .environmentObject(navigationController)
        }
    }
}
