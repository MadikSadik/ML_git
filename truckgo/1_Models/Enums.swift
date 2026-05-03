import Foundation

enum UserRole: String, Codable, CaseIterable {
    case customer = "Customer"
    case driver = "Driver"
    case admin = "Admin"
    
    var localizationKey: String {
        switch self {
        case .customer: return "role.customer"
        case .driver:   return "role.driver"
        case .admin:    return "role.admin"
        }
    }
    
    static var signupOptions: [UserRole] { [.customer, .driver] }
}

enum OrderStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case accepted = "Accepted"
    case inTransit = "In Transit"
    case delivered = "Delivered"
    
    var localizationKey: String {
        switch self {
        case .pending:   return "status.pending"
        case .accepted:  return "status.accepted"
        case .inTransit: return "status.inTransit"
        case .delivered: return "status.delivered"
        }
    }
    
    var color: String {
        switch self {
        case .pending:   return "orange"
        case .accepted:  return "blue"
        case .inTransit: return "purple"
        case .delivered: return "green"
        }
    }
    
    var next: OrderStatus? {
        switch self {
        case .pending:   return .accepted
        case .accepted:  return .inTransit
        case .inTransit: return .delivered
        case .delivered: return nil
        }
    }
}

enum CargoType: String, Codable, CaseIterable {
    case general = "General"
    case fragile = "Fragile"
    case refrigerated = "Refrigerated"
    case heavy = "Heavy"
    case furniture = "Furniture"
    
    var localizationKey: String {
        switch self {
        case .general:      return "cargo.general"
        case .fragile:      return "cargo.fragile"
        case .refrigerated: return "cargo.refrigerated"
        case .heavy:        return "cargo.heavy"
        case .furniture:    return "cargo.furniture"
        }
    }
}
