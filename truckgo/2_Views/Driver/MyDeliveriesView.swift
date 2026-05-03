import SwiftUI
import SwiftData

struct MyDeliveriesView: View {
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Query(sort: \Order.createdAt, order: .reverse) private var orders: [Order]
    
    var t: L { L(settings) }
    var myDeliveries: [Order] {
        orders.filter { $0.driverEmail == session.currentUserEmail }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if myDeliveries.isEmpty {
                    ContentUnavailableView(t.s("order.noActiveJobs"),
                        systemImage: "truck.box",
                        description: Text(t.s("order.acceptHint")))
                } else {
                    List(myDeliveries) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRow(order: order)
                        }
                    }
                }
            }
            .navigationTitle(t.s("tab.myJobs"))
            .appBackground()
        }
    }
}
