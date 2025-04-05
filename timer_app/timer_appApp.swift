import SwiftUI

@main
struct timer_appApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(themeManager)
            }
        }
    }
}
