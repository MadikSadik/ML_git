import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Query private var users: [User]
    
    var currentUser: User? {
        users.first(where: { $0.email == session.currentUserEmail })
    }
    
    var t: L { L(settings) }
    
    var body: some View {
        @Bindable var settings = settings
        
        NavigationStack {
            Form {
                if let user = currentUser {
                    Section {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Avatar(symbol: user.avatarSymbol,
                                       colorHex: user.avatarColorHex,
                                       size: 100)
                                Text(user.name).font(.title2).bold()
                                Text(t.s(user.role.localizationKey))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                    }
                    
                    Section(t.s("profile.account")) {
                        LabeledContent(t.s("profile.email"), value: user.email)
                        LabeledContent(t.s("profile.phoneLabel"), value: user.phone)
                    }
                    
                    Section {
                        NavigationLink(t.s("profile.editProfile")) {
                            EditProfileView(user: user)
                        }
                    }
                }
                
                Section(t.s("profile.settings")) {
                    Picker(t.s("profile.appearance"), selection: $settings.colorSchemePreference) {
                        ForEach(ColorSchemePreference.allCases, id: \.self) { pref in
                            Text(t.s(pref.localizationKey)).tag(pref)
                        }
                    }
                    
                    Picker(t.s("profile.language"), selection: $settings.language) {
                        ForEach(AppLanguage.allCases, id: \.self) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                }
                
                Section {
                    Button(t.s("profile.logOut"), role: .destructive) {
                        session.logout()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle(t.s("tab.profile"))
            .appBackground()
        }
    }
}
