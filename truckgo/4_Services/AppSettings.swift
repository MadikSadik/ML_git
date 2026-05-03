import SwiftUI

@Observable
final class AppSettings {
    var colorSchemePreference: ColorSchemePreference {
        didSet {
            UserDefaults.standard.set(colorSchemePreference.rawValue, forKey: "colorScheme")
        }
    }
    
    var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "language")
        }
    }
    
    init() {
        let scheme = UserDefaults.standard.string(forKey: "colorScheme") ?? ColorSchemePreference.system.rawValue
        self.colorSchemePreference = ColorSchemePreference(rawValue: scheme) ?? .system
        
        let lang = UserDefaults.standard.string(forKey: "language") ?? AppLanguage.english.rawValue
        self.language = AppLanguage(rawValue: lang) ?? .english
    }
}

enum ColorSchemePreference: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var localizationKey: String {
        switch self {
        case .system: return "appearance.system"
        case .light:  return "appearance.light"
        case .dark:   return "appearance.dark"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case russian = "Русский"
}
