import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(SessionManager.self) private var session
    @Query private var users: [User]
    
    var body: some View {
        Group {
            if session.isLoggedIn, currentUserExists {
                switch session.currentUserRole {
                case .customer: CustomerHomeView()
                case .driver:   DriverHomeView()
                case .admin:    AdminHomeView()
                case .none:     LoginView()
                }
            } else {
                LoginView()
            }
        }
        .onChange(of: users.count) { _, _ in
            if session.isLoggedIn && !currentUserExists {
                session.logout()
            }
        }
    }
    
    private var currentUserExists: Bool {
        guard let email = session.currentUserEmail else { return false }
        return users.contains(where: { $0.email == email })
    }
}
