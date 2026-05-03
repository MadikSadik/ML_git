import Foundation
import SwiftUI

@Observable
final class SessionManager {
    var currentUserEmail: String?
    var currentUserRole: UserRole?
    var currentUserName: String?
    
    var isLoggedIn: Bool { currentUserEmail != nil }
    
    func login(email: String, role: UserRole, name: String) {
        self.currentUserEmail = email
        self.currentUserRole = role
        self.currentUserName = name
    }
    
    func logout() {
        self.currentUserEmail = nil
        self.currentUserRole = nil
        self.currentUserName = nil
    }
}
