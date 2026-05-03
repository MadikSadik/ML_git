import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Environment(\.colorScheme) private var colorScheme
    @Query private var users: [User]
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showSignup = false
    
    var t: L { L(settings) }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: colorScheme == .dark
                        ? [Color(hex: "#0F172A"), Color(hex: "#1E293B")]
                        : [Color(hex: "#3B82F6").opacity(0.2), Color(hex: "#F8FAFC")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "truck.box.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)
                    
                    Text("TruckGO").font(.largeTitle).bold()
                    Text(t.s("app.tagline")).foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        TextField(t.s("auth.email"), text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                        
                        SecureField(t.s("auth.password"), text: $password)
                            .textFieldStyle(.roundedBorder)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage).foregroundStyle(.red).font(.caption)
                        }
                        
                        Button(t.s("auth.login")) { login() }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .frame(maxWidth: .infinity)
                        
                        Button(t.s("auth.noAccount")) { showSignup = true }
                            .font(.footnote)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showSignup) {
                SignupView()
            }
        }
    }
    
    private func login() {
        guard let user = users.first(where: { $0.email == email && $0.password == password }) else {
            errorMessage = t.s("auth.invalidCredentials")
            return
        }
        session.login(email: user.email, role: user.role, name: user.name)
    }
}
