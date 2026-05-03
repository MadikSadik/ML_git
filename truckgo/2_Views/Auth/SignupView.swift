import SwiftUI
import SwiftData

struct SignupView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var role: UserRole = .customer
    @State private var errorMessage = ""
    
    var t: L { L(settings) }
    
    var body: some View {
        Form {
            Section(t.s("auth.personalInfo")) {
                TextField(t.s("auth.fullName"), text: $name)
                TextField(t.s("auth.email"), text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                TextField(t.s("auth.phone"), text: $phone)
                    .keyboardType(.phonePad)
                SecureField(t.s("auth.password"), text: $password)
            }
            
            Section(t.s("auth.iAmA")) {
                Picker(t.s("auth.role"), selection: $role) {
                    ForEach(UserRole.signupOptions, id: \.self) { r in
                        Text(t.s(r.localizationKey)).tag(r)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            if !errorMessage.isEmpty {
                Section { Text(errorMessage).foregroundStyle(.red) }
            }
            
            Section {
                Button(t.s("auth.createAccount")) { signup() }
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(t.s("auth.signup"))
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
    }
    
    private func signup() {
        guard !name.isEmpty, !email.isEmpty, !phone.isEmpty, !password.isEmpty else {
            errorMessage = t.s("auth.fillAllFields")
            return
        }
        guard !users.contains(where: { $0.email == email }) else {
            errorMessage = t.s("auth.emailExists")
            return
        }
        
        let newUser = User(email: email, password: password, name: name, phone: phone, role: role)
        context.insert(newUser)
        try? context.save()
        
        session.login(email: newUser.email, role: newUser.role, name: newUser.name)
        dismiss()
    }
}
