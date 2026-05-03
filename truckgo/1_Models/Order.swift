import Foundation
import SwiftData

@Model
final class Order {
    var id: UUID
    var customerEmail: String
    var driverEmail: String?
    var fromCity: String
    var toCity: String
    var cargoTypeRaw: String
    var weight: Double
    var lengthCm: Double
    var widthCm: Double
    var heightCm: Double
    var price: Double
    var pickupDate: Date
    var statusRaw: String
    var createdAt: Date
    
    var cargoType: CargoType {
        get { CargoType(rawValue: cargoTypeRaw) ?? .general }
        set { cargoTypeRaw = newValue.rawValue }
    }
    
    var status: OrderStatus {
        get { OrderStatus(rawValue: statusRaw) ?? .pending }
        set { statusRaw = newValue.rawValue }
    }
    
    init(customerEmail: String, fromCity: String, toCity: String,
         cargoType: CargoType, weight: Double,
         lengthCm: Double, widthCm: Double, heightCm: Double,
         price: Double, pickupDate: Date) {
        self.id = UUID()
        self.customerEmail = customerEmail
        self.driverEmail = nil
        self.fromCity = fromCity
        self.toCity = toCity
        self.cargoTypeRaw = cargoType.rawValue
        self.weight = weight
        self.lengthCm = lengthCm
        self.widthCm = widthCm
        self.heightCm = heightCm
        self.price = price
        self.pickupDate = pickupDate
        self.statusRaw = OrderStatus.pending.rawValue
        self.createdAt = Date()
    }
}
