import SwiftUI
import SwiftData

struct AdminOrdersView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppSettings.self) private var settings
    @Query(sort: \Order.createdAt, order: .reverse) private var orders: [Order]
    
    var t: L { L(settings) }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(orders) { order in
                    NavigationLink(destination: AdminEditOrderView(order: order)) {
                        OrderRow(order: order)
                    }
                }
                .onDelete(perform: deleteOrders)
            }
            .navigationTitle("\(t.s("admin.allOrders")) (\(orders.count))")
            .toolbar { EditButton() }
            .appBackground()
            .overlay {
                if orders.isEmpty {
                    ContentUnavailableView(t.s("admin.noOrdersAdmin"),
                        systemImage: "shippingbox",
                        description: Text(t.s("admin.ordersAppear")))
                }
            }
        }
    }
    
    private func deleteOrders(at offsets: IndexSet) {
        for index in offsets { context.delete(orders[index]) }
        try? context.save()
    }
}
