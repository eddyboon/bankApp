import SwiftUI
import Firebase

@main
struct bankAppApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @State var path = NavigationPath()
    
    init() {
        FirebaseApp.configure()
    }
    
    enum AppScreen: Hashable {
        case login
        case dashboard
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                LoginView()
                    .onChange(of: authViewModel.isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            path.append(AppScreen.dashboard)
                        } else {
                            path.removeLast()
                        }
                    }
                    .navigationDestination(for: AppScreen.self) { screen in
                        switch screen {
                        case .login:
                            LoginView()
                        case .dashboard:
                            DashboardView()
                        }
                    }
            }
            .environmentObject(authViewModel)
        }
    }
}
