import SwiftUI

// Theme structure to hold color pairs
struct AppTheme {
    let background: String
    let accent: String
    let usesDarkText: Bool  // Flag to determine text color
}

// Theme manager to store theme data
class ThemeManager: ObservableObject {
    @Published var currentThemeIndex: Int = 3 // Start with the third theme (current one)

    // Define the themes
    let themes: [AppTheme] = [
        AppTheme(background: "#4E454B", accent: "#F0EEF0", usesDarkText: true),  // First theme - light accent, use black text
        AppTheme(background: "#387FD3", accent: "#2CBAB4", usesDarkText: false), // Second theme - dark accent, use white text
        AppTheme(background: "#D9535A", accent: "#333C45", usesDarkText: false),// Third theme - dark accent, use white text
        AppTheme(background: "#482661", accent: "#8344C1", usesDarkText: false),
        AppTheme(background: "#323650", accent: "#2A9EC1", usesDarkText: false),
        AppTheme(background: "#CD6A5C", accent: "#35C3BD", usesDarkText: true)
    ]

    // Function to cycle to the next theme
    func nextTheme() {
        currentThemeIndex = (currentThemeIndex + 1) % themes.count
    }

    // Current theme colors
    var backgroundColor: Color {
        Color(hex: themes[currentThemeIndex].background)
    }

    var accentColor: Color {
        Color(hex: themes[currentThemeIndex].accent)
    }

    // Text color based on the theme
    var textColor: Color {
        themes[currentThemeIndex].usesDarkText ? .black : .white
    }
}
