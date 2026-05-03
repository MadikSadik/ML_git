import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var settings
    
    let user: User
    
    @State private var name = ""
    @State private var phone = ""
    @State private var newPassword = ""
    @State private var avatarSymbol = "person.fill"
    @State private var avatarColorHex = "#3B82F6"
    @State private var showAvatarPicker = false
    @State private var errorMessage = ""
    
    var t: L { L(settings) }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Avatar(symbol: avatarSymbol, colorHex: avatarColorHex, size: 100)
                        Button(t.s("profile.changeAvatar")) {
                            showAvatarPicker = true
                        }
                        .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }
            
            Section(t.s("auth.personalInfo")) {
                TextField(t.s("profile.name"), text: $name)
                TextField(t.s("auth.phone"), text: $phone)
                    .keyboardType(.phonePad)
                LabeledContent(t.s("auth.email"), value: user.email)
                    .foregroundStyle(.secondary)
            }
            
            Section(t.s("profile.changePassword")) {
                SecureField(t.s("profile.newPasswordHint"), text: $newPassword)
            }
            
            if !errorMessage.isEmpty {
                Section { Text(errorMessage).foregroundStyle(.red) }
            }
            
            Section {
                Button(t.s("profile.saveChanges")) { save() }
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(t.s("profile.editTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
        .onAppear {
            name = user.name
            phone = user.phone
            avatarSymbol = user.avatarSymbol
            avatarColorHex = user.avatarColorHex
        }
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerView(
                selectedSymbol: $avatarSymbol,
                selectedColorHex: $avatarColorHex
            )
        }
    }
    
    private func save() {
        guard !name.isEmpty, !phone.isEmpty else {
            errorMessage = t.s("profile.nameEmptyError")
            return
        }
        
        user.name = name
        user.phone = phone
        user.avatarSymbol = avatarSymbol
        user.avatarColorHex = avatarColorHex
        
        if !newPassword.isEmpty {
            user.password = newPassword
        }
        
        try? context.save()
        dismiss()
    }
}
