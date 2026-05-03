import SwiftUI

struct AdminHomeView: View {
    @Environment(AppSettings.self) private var settings
    var t: L { L(settings) }
    
    var body: some View {
        TabView {
            AdminUsersView()
                .tabItem { Label(t.s("tab.users"), systemImage: "person.3.fill") }
            
            AdminOrdersView()
                .tabItem { Label(t.s("tab.orders"), systemImage: "shippingbox.fill") }
            
            ProfileView()
                .tabItem { Label(t.s("tab.profile"), systemImage: "person.fill") }
        }
    }
}
