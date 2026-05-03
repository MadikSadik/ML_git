import SwiftUI

struct OrderRow: View {
    let order: Order
    @Environment(AppSettings.self) private var settings
    
    var t: L { L(settings) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(t.s(Cities.localizationKey(for: order.fromCity))) → \(t.s(Cities.localizationKey(for: order.toCity)))")
                    .font(.headline)
                Spacer()
                StatusBadge(status: order.status)
            }
            HStack {
                Label(t.s(order.cargoType.localizationKey), systemImage: "shippingbox")
                Spacer()
                Text("\(Int(order.weight)) kg")
                Text("•")
                Text("\(Int(order.price)) ₸")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: OrderStatus
    @Environment(AppSettings.self) private var settings
    
    var t: L { L(settings) }
    
    var color: Color {
        switch status.color {
        case "orange":  return .orange
        case "blue":    return .blue
        case "purple":  return .purple
        case "green":   return .green
        default:        return .gray
        }
    }
    
    var body: some View {
        Text(t.s(status.localizationKey))
            .font(.caption2).bold()
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

struct RoleBadge: View {
    let role: UserRole
    @Environment(AppSettings.self) private var settings
    
    var t: L { L(settings) }
    
    var color: Color {
        switch role {
        case .customer: return .blue
        case .driver:   return .green
        case .admin:    return .red
        }
    }
    
    var body: some View {
        Text(t.s(role.localizationKey))
            .font(.caption2).bold()
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
