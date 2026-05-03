import Foundation

enum Cities {
    static let all: [String] = [
        "Almaty",
        "Astana",
        "Shymkent",
        "Karaganda",
        "Aktobe",
        "Taraz",
        "Pavlodar",
        "Ust-Kamenogorsk",
        "Semey",
        "Atyrau",
        "Kyzylorda",
        "Aktau"
    ]
    
    /// Maps a city name to its localization key
    static func localizationKey(for city: String) -> String {
        "city.\(city.lowercased().replacingOccurrences(of: "-", with: ""))"
    }
}
