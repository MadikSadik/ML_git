import SwiftUI
import SwiftData

struct AdminUsersView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Query(sort: \User.name) private var users: [User]
    
    @State private var deleteErrorMessage: String?
    
    var t: L { L(settings) }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    NavigationLink(destination: AdminEditUserView(user: user)) {
                        HStack(spacing: 12) {
                            Avatar(symbol: user.avatarSymbol,
                                   colorHex: user.avatarColorHex,
                                   size: 44)
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(user.name).bold()
                                    Spacer()
                                    RoleBadge(role: user.role)
                                }
                                Text(user.email).font(.caption).foregroundStyle(.secondary)
                                Text(user.phone).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteUsers)
            }
            .navigationTitle("\(t.s("admin.allUsers")) (\(users.count))")
            .toolbar { EditButton() }
            .appBackground()
            .alert(t.s("admin.cannotDelete"),
                   isPresented: .constant(deleteErrorMessage != nil)) {
                Button(t.s("admin.ok")) { deleteErrorMessage = nil }
            } message: {
                Text(deleteErrorMessage ?? "")
            }
        }
    }
    
    private func deleteUsers(at offsets: IndexSet) {
        var blockedReason: String?
        
        for index in offsets {
            let user = users[index]
            
            if user.email == session.currentUserEmail {
                blockedReason = t.s("admin.cantDeleteSelf")
                continue
            }
            
            if user.role == .admin {
                let admins = users.filter { $0.role == .admin }
                if admins.count <= 1 {
                    blockedReason = t.s("admin.cantDeleteLastAdmin")
                    continue
                }
            }
            
            context.delete(user)
        }
        
        try? context.save()
        
        if let reason = blockedReason {
            deleteErrorMessage = reason
        }
    }
}
