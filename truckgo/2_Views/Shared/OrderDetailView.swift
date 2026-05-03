import SwiftUI
import SwiftData

struct OrderDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss
    
    let order: Order
    
    var t: L { L(settings) }
    var isDriver: Bool { session.currentUserRole == .driver }
    var isMyDelivery: Bool { order.driverEmail == session.currentUserEmail }
    
    var body: some View {
        Form {
            Section(t.s("order.route")) {
                LabeledContent(t.s("order.from"),
                               value: t.s(Cities.localizationKey(for: order.fromCity)))
                LabeledContent(t.s("order.to"),
                               value: t.s(Cities.localizationKey(for: order.toCity)))
            }
            
            Section(t.s("order.cargo")) {
                LabeledContent(t.s("order.type"),
                               value: t.s(order.cargoType.localizationKey))
                LabeledContent(t.s("order.weight"), value: "\(Int(order.weight)) kg")
                LabeledContent(t.s("order.dimensions"),
                               value: "\(Int(order.lengthCm)) × \(Int(order.widthCm)) × \(Int(order.heightCm)) cm")
            }
            
            Section(t.s("order.pickupPrice")) {
                LabeledContent(t.s("order.pickup"),
                               value: order.pickupDate.formatted(date: .abbreviated, time: .omitted))
                LabeledContent(t.s("order.price"), value: "\(Int(order.price)) ₸")
            }
            
            Section(t.s("order.status")) {
                HStack {
                    Text(t.s("order.current"))
                    Spacer()
                    StatusBadge(status: order.status)
                }
            }
            
            if isDriver {
                if order.status == .pending {
                    Section {
                        Button(t.s("order.accept")) { acceptOrder() }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .listRowBackground(Color.blue)
                    }
                } else if isMyDelivery, let nextStatus = order.status.next {
                    Section {
                        Button("\(t.s("order.markAs")) \(t.s(nextStatus.localizationKey))") {
                            advanceStatus()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .listRowBackground(Color.green)
                    }
                }
            }
        }
        .navigationTitle(t.s("order.details"))
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
    }
    
    private func acceptOrder() {
        order.driverEmail = session.currentUserEmail
        order.status = .accepted
        try? context.save()
        dismiss()
    }
    
    private func advanceStatus() {
        if let next = order.status.next {
            order.status = next
            try? context.save()
        }
    }
}
