import SwiftUI
import SwiftData

struct MyOrdersView: View {
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Query(sort: \Order.createdAt, order: .reverse) private var orders: [Order]
    
    var t: L { L(settings) }
    
    var myOrders: [Order] {
        orders.filter { $0.customerEmail == session.currentUserEmail }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if myOrders.isEmpty {
                    ContentUnavailableView(t.s("order.noOrders"),
                        systemImage: "shippingbox",
                        description: Text(t.s("order.tapNew")))
                } else {
                    List(myOrders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRow(order: order)
                        }
                    }
                }
            }
            .navigationTitle(t.s("tab.myOrders"))
            .appBackground()
        }
    }
}
