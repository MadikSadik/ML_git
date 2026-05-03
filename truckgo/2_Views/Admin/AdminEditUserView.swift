import SwiftUI
import SwiftData

struct AdminEditUserView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss
    
    let user: User
    
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var role: UserRole = .customer
    @State private var showDeleteConfirm = false
    @State private var showPromotionConfirm = false
    @State private var deleteErrorMessage: String?
    @State private var saveErrorMessage: String?
    
    var t: L { L(settings) }
    
    var body: some View {
        Form {
            Section(t.s("admin.info")) {
                LabeledContent(t.s("auth.email"), value: user.email)
                TextField(t.s("profile.name"), text: $name)
                TextField(t.s("auth.phone"), text: $phone)
            }
            
            Section(t.s("auth.role")) {
                Picker(t.s("auth.role"), selection: $role) {
                    ForEach(UserRole.allCases, id: \.self) { r in
                        Text(t.s(r.localizationKey)).tag(r)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                Button(t.s("profile.saveChanges")) { save() }
                    .frame(maxWidth: .infinity)
            }
            
            Section {
                Button(t.s("admin.deleteUser"), role: .destructive) {
                    showDeleteConfirm = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(t.s("admin.editUser"))
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
        .onAppear {
            name = user.name
            phone = user.phone
            role = user.role
        }
        .alert(t.s("admin.confirmDeleteUser"), isPresented: $showDeleteConfirm) {
            Button(t.s("admin.cancel"), role: .cancel) { }
            Button(t.s("admin.delete"), role: .destructive) { delete() }
        } message: {
            Text(t.s("admin.cannotUndone"))
        }
        .alert(t.s("admin.cannotDelete"),
               isPresented: .constant(deleteErrorMessage != nil)) {
            Button(t.s("admin.ok")) { deleteErrorMessage = nil }
        } message: {
            Text(deleteErrorMessage ?? "")
        }
        .alert(t.s("admin.cannotSave"),
               isPresented: .constant(saveErrorMessage != nil)) {
            Button(t.s("admin.ok")) { saveErrorMessage = nil }
        } message: {
            Text(saveErrorMessage ?? "")
        }
        .alert(t.s("admin.promoteTitle"), isPresented: $showPromotionConfirm) {
            Button(t.s("admin.cancel"), role: .cancel) { }
            Button(t.s("admin.promote"), role: .destructive) { performSave() }
        } message: {
            Text(String(format: t.s("admin.promoteMessage"), name))
        }
    }
    
    private func save() {
        if user.email == session.currentUserEmail && role != .admin {
            saveErrorMessage = t.s("admin.cantChangeOwnRole")
            return
        }
        
        if user.role == .admin && role != .admin {
            let descriptor = FetchDescriptor<User>(
                predicate: #Predicate { $0.roleRaw == "Admin" }
            )
            let admins = (try? context.fetch(descriptor)) ?? []
            if admins.count <= 1 {
                saveErrorMessage = t.s("admin.cantChangeLastAdminRole")
                return
            }
        }
        
        if user.role != .admin && role == .admin {
            showPromotionConfirm = true
            return
        }
        
        performSave()
    }
    
    private func performSave() {
        user.name = name
        user.phone = phone
        user.roleRaw = role.rawValue
        try? context.save()
        dismiss()
    }
    
    private func delete() {
        if user.email == session.currentUserEmail {
            deleteErrorMessage = t.s("admin.cantDeleteSelf")
            return
        }
        
        if user.role == .admin {
            let descriptor = FetchDescriptor<User>(
                predicate: #Predicate { $0.roleRaw == "Admin" }
            )
            let admins = (try? context.fetch(descriptor)) ?? []
            if admins.count <= 1 {
                deleteErrorMessage = t.s("admin.cantDeleteLastAdmin")
                return
            }
        }
        
        context.delete(user)
        try? context.save()
        dismiss()
    }
}
