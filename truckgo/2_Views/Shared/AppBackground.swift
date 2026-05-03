import SwiftUI

struct AppBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color(hex: "#0F172A"), Color(hex: "#1E293B")]
                    : [Color(hex: "#EFF6FF"), Color(hex: "#F8FAFC")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            content
                .scrollContentBackground(.hidden)
        }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackground())
    }
}
