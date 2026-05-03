import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var email: String
    var password: String
    var name: String
    var phone: String
    var roleRaw: String
    var avatarSymbol: String
    var avatarColorHex: String
    
    var role: UserRole {
        get { UserRole(rawValue: roleRaw) ?? .customer }
        set { roleRaw = newValue.rawValue }
    }
    
    init(email: String, password: String, name: String, phone: String,
         role: UserRole,
         avatarSymbol: String = "person.fill",
         avatarColorHex: String = "#3B82F6") {
        self.email = email
        self.password = password
        self.name = name
        self.phone = phone
        self.roleRaw = role.rawValue
        self.avatarSymbol = avatarSymbol
        self.avatarColorHex = avatarColorHex
    }
}
