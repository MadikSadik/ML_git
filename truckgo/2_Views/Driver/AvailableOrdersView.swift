import SwiftUI
import SwiftData

struct AvailableOrdersView: View {
    @Environment(AppSettings.self) private var settings
    @Query(sort: \Order.createdAt, order: .reverse) private var orders: [Order]
    
    var t: L { L(settings) }
    var availableOrders: [Order] {
        orders.filter { $0.status == .pending }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if availableOrders.isEmpty {
                    ContentUnavailableView(t.s("order.noAvailable"),
                        systemImage: "shippingbox",
                        description: Text(t.s("order.checkLater")))
                } else {
                    List(availableOrders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRow(order: order)
                        }
                    }
                }
            }
            .navigationTitle(t.s("tab.available"))
            .appBackground()
        }
    }
}
