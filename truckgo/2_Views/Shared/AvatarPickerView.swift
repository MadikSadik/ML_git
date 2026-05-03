import SwiftUI

struct AvatarPickerView: View {
    @Binding var selectedSymbol: String
    @Binding var selectedColorHex: String
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var settings
    
    var t: L { L(settings) }
    
    let symbols = [
        "person.fill", "person.crop.circle.fill", "face.smiling",
        "truck.box.fill", "shippingbox.fill", "car.fill",
        "star.fill", "heart.fill", "bolt.fill",
        "leaf.fill", "flame.fill", "drop.fill",
        "moon.fill", "sun.max.fill", "cloud.fill",
        "gamecontroller.fill", "music.note", "book.fill",
        "airplane", "bicycle", "scooter",
        "pawprint.fill", "tortoise.fill", "hare.fill"
    ]
    
    let colors = [
        "#3B82F6", "#10B981", "#F59E0B", "#EF4444",
        "#8B5CF6", "#EC4899", "#06B6D4", "#84CC16",
        "#6366F1", "#F97316", "#14B8A6", "#A855F7"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Avatar(symbol: selectedSymbol, colorHex: selectedColorHex, size: 100)
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(t.s("avatar.color")).font(.headline)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(Color(hex: color))
                                    .frame(height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColorHex == color ? 3 : 0)
                                    )
                                    .onTapGesture { selectedColorHex = color }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(t.s("avatar.icon")).font(.headline)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                            ForEach(symbols, id: \.self) { symbol in
                                Image(systemName: symbol)
                                    .font(.system(size: 24))
                                    .foregroundStyle(selectedSymbol == symbol ? .white : .primary)
                                    .frame(width: 56, height: 56)
                                    .background(
                                        selectedSymbol == symbol
                                            ? Color(hex: selectedColorHex)
                                            : Color(.systemGray5)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .onTapGesture { selectedSymbol = symbol }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(t.s("avatar.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(t.s("avatar.done")) { dismiss() }
                }
            }
        }
    }
}
