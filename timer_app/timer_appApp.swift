import SwiftUI
import AVFoundation // Import AVFoundation

@main
struct timer_appApp: App {
    @StateObject private var themeManager = ThemeManager()

    init() {
        // Configure the audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
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
