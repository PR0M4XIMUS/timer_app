import SwiftUI
import Foundation // Required for Scanner

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgb: UInt64 = 0
        if scanner.scanHexInt64(&rgb) {
            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue)
        } else {
            self.init(red: 1, green: 0, blue: 0) // Default to red if invalid hex
            print("⚠️ Invalid hex color: \(hex)")
        }
    }
}
