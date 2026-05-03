import SwiftUI

struct CustomerHomeView: View {
    @Environment(AppSettings.self) private var settings
    var t: L { L(settings) }
    
    var body: some View {
        TabView {
            MyOrdersView()
                .tabItem { Label(t.s("tab.myOrders"), systemImage: "list.bullet") }
            
            CreateOrderView()
                .tabItem { Label(t.s("tab.newOrder"), systemImage: "plus.circle.fill") }
            
            ProfileView()
                .tabItem { Label(t.s("tab.profile"), systemImage: "person.fill") }
        }
    }
}
