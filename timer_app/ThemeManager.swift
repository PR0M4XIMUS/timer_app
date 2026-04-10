import SwiftUI

struct AppTheme {
    let background: String
    let accent: String
    let usesDarkText: Bool
}

class ThemeManager: ObservableObject {
    @Published var currentThemeIndex: Int = 3

    let themes: [AppTheme] = [
        AppTheme(background: "#4E454B", accent: "#F0EEF0", usesDarkText: false), // Charcoal
        AppTheme(background: "#387FD3", accent: "#2CBAB4", usesDarkText: false), // Ocean Blue
        AppTheme(background: "#D9535A", accent: "#333C45", usesDarkText: false), // Bold Red
        AppTheme(background: "#482661", accent: "#8344C1", usesDarkText: false), // Royal Purple
        AppTheme(background: "#323650", accent: "#2A9EC1", usesDarkText: false), // Slate Blue
        AppTheme(background: "#CD6A5C", accent: "#35C3BD", usesDarkText: true),  // Warm Coral
    ]

    func nextTheme() {
        currentThemeIndex = (currentThemeIndex + 1) % themes.count
    }

    var backgroundColor: Color {
        Color(hex: themes[currentThemeIndex].background)
    }

    var accentColor: Color {
        Color(hex: themes[currentThemeIndex].accent)
    }

    var textColor: Color {
        themes[currentThemeIndex].usesDarkText ? .black : .white
    }

    /// Drives `.ultraThinMaterial` appearance — dark material on dark themes, light on light.
    var preferredColorScheme: ColorScheme {
        themes[currentThemeIndex].usesDarkText ? .light : .dark
    }
}
