import SwiftUI
import AVFoundation
import UserNotifications

@main
struct timer_appApp: App {
    @StateObject private var themeManager = ThemeManager()

    init() {
        // Audio session — allow mixing with other apps' audio
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
        }

        // Request permission to show local notifications (for background timer completion)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(themeManager)
            }
        }
    }
}
