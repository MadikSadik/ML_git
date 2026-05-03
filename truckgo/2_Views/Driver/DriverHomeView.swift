import SwiftUI

struct DriverHomeView: View {
    @Environment(AppSettings.self) private var settings
    var t: L { L(settings) }
    
    var body: some View {
        TabView {
            AvailableOrdersView()
                .tabItem { Label(t.s("tab.available"), systemImage: "shippingbox") }
            
            MyDeliveriesView()
                .tabItem { Label(t.s("tab.myJobs"), systemImage: "truck.box") }
            
            ProfileView()
                .tabItem { Label(t.s("tab.profile"), systemImage: "person.fill") }
        }
    }
}
