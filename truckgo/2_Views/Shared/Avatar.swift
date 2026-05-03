import SwiftUI

struct Avatar: View {
    let symbol: String
    let colorHex: String
    var size: CGFloat = 40
    
    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size * 0.5))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(Color(hex: colorHex))
            .clipShape(Circle())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    VStack(spacing: 12) {
        Avatar(symbol: "person.fill", colorHex: "#3B82F6", size: 60)
        Avatar(symbol: "truck.box.fill", colorHex: "#10B981", size: 60)
        Avatar(symbol: "star.fill", colorHex: "#F59E0B", size: 60)
    }
}
