import SwiftUI
import Firebase

@main
struct bankAppApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var navigationController = NavigationController()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationController.path) {
                LoginView()
                    .onChange(of: authViewModel.isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            navigationController.path.append(NavigationController.AppScreen.dashboard)
                        }
                        else {
                            navigationController.path.removeLast()
                        }
                    }
                    .navigationDestination(for: NavigationController.AppScreen.self) { screen in
                        switch screen {
                        case .login:
                            LoginView()
                        case .dashboard:
                            DashboardView()
                                .navigationBarBackButtonHidden(true)
                        case .profile:
                            ProfileView()
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
