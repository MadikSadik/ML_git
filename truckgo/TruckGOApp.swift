import SwiftUI
import SwiftData

@main
struct TruckGOApp: App {
    @State private var session = SessionManager()
    @State private var settings = AppSettings()
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: User.self, Order.self)
            seedAdminIfNeeded(container.mainContext)
        } catch {
            fatalError("Failed to set up SwiftData: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
                .environment(settings)
                .preferredColorScheme(settings.colorSchemePreference.colorScheme)
        }
        .modelContainer(container)
    }
    
    private func seedAdminIfNeeded(_ context: ModelContext) {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.roleRaw == "Admin" }
        )
        let existingAdmins = (try? context.fetch(descriptor)) ?? []
        guard existingAdmins.isEmpty else { return }
        
        let emailDescriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == "admin@truckgo.com" }
        )
        if let existing = try? context.fetch(emailDescriptor).first {
            existing.roleRaw = UserRole.admin.rawValue
        } else {
            let admin = User(
                email: "admin@truckgo.com",
                password: "admin123",
                name: "Admin",
                phone: "+77000000000",
                role: .admin
            )
            context.insert(admin)
        }
        try? context.save()
    }
}
