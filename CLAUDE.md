# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a native iOS SwiftUI app. All building and running is done through Xcode:

```bash
open timer_app.xcodeproj   # Open in Xcode
# Then ⌘+R to build and run on simulator/device
```

There are no unit tests, no linting tools, and no package manager (no SPM dependencies, no CocoaPods).

## Architecture

**State management**: `ThemeManager` is an `ObservableObject` instantiated once in `timer_appApp.swift` as `@StateObject` and injected into all views via `.environmentObject()`. Views access it with `@EnvironmentObject`.

**Data flow**: Timer state (`savedTimes`, `recentlyUsedTimes`, `selectedHour/Minute/Second`) lives in `ContentView` as `@State`. `SavedTimesView` receives these as `@Binding`. Saved times and the selected theme index are persisted via `@AppStorage` (JSON-encoded strings for arrays, plain `Int` for the theme). No CoreData.

**Navigation**: Single `NavigationStack` in `timer_appApp.swift`. Both `ContentView` and `SavedTimesView` hide the system navigation bar (`.toolbar(.hidden, for: .navigationBar)`) and render their own floating glass pill navbar. `SavedTimesView` is pushed via `NavigationLink` from `ContentView`'s pill; swipe-to-back still works via the interactive pop gesture.

**Theme system**: `AppTheme` holds two hex color strings (`background`, `accent`) plus `usesDarkText: Bool`. `ThemeManager.nextTheme()` cycles `currentThemeIndex` (persisted to UserDefaults via `didSet`). `preferredColorScheme` (`.light`/`.dark`) is derived from `usesDarkText` and applied via `.environment(\.colorScheme, ...)` — this drives `.ultraThinMaterial` to render as the correct light/dark frosted glass automatically. `Color(hex:)` in `ColorExtensions.swift` parses hex strings at render time.

**Timer mechanics**: A `Timer.scheduledTimer` fires every second to decrement `remainingSeconds`. A separate `withAnimation(.linear(duration:))` drives `progress` (0→1) for the circular `trim` indicator. A `UNLocalNotification` is scheduled at start so the alarm fires even when the app is backgrounded. Completion via `DispatchQueue.main.asyncAfter` fires the in-app sound and success haptic. These timers are not synchronized — only approximately aligned.

**Audio**: `SoundManager` is a singleton using `AVAudioPlayer`. The audio session (`.playback`, `.mixWithOthers`) is configured at app launch in `timer_appApp.init()`. `stopSound()` is called on reset.

## iOS Design Target

The app targets iOS 16.0+ but the design direction is iOS 26 Liquid Glass / glassmorphism aesthetic — translucent `.ultraThinMaterial` panels, soft blur, no hard borders, rounded-everything, `.monospacedDigit()` timers.
