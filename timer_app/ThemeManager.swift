import SwiftUI

struct AppTheme {
    let background: String
    let accent: String
    let usesDarkText: Bool
}

class ThemeManager: ObservableObject {
    @Published var currentThemeIndex: Int {
        didSet { UserDefaults.standard.set(currentThemeIndex, forKey: "themeIndex") }
    }

    let themes: [AppTheme] = [
        AppTheme(background: "#4E454B", accent: "#F0EEF0", usesDarkText: false), // Charcoal
        AppTheme(background: "#387FD3", accent: "#2CBAB4", usesDarkText: false), // Ocean Blue
        AppTheme(background: "#D9535A", accent: "#E8A0A3", usesDarkText: false), // Bold Red
        AppTheme(background: "#482661", accent: "#A97BE8", usesDarkText: false), // Royal Purple
        AppTheme(background: "#323650", accent: "#2A9EC1", usesDarkText: false), // Slate Blue
        AppTheme(background: "#CD6A5C", accent: "#35C3BD", usesDarkText: true),  // Warm Coral
    ]

    init() {
        if let stored = UserDefaults.standard.object(forKey: "themeIndex") as? Int,
           stored < 6 {
            currentThemeIndex = stored
        } else {
            currentThemeIndex = 3 // default: Royal Purple
        }
    }

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

    /// Drives `.ultraThinMaterial` appearance — dark glass on dark themes, light glass on light.
    var preferredColorScheme: ColorScheme {
        themes[currentThemeIndex].usesDarkText ? .light : .dark
    }
}
