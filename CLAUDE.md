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

**Data flow**: All timer state (`savedTimes`, `recentlyUsedTimes`, `selectedHour/Minute/Second`) lives in `ContentView` as `@State`. `SavedTimesView` receives these as `@Binding` — there is no persistence layer (no UserDefaults, no CoreData); saved times are lost on app restart.

**Navigation**: Single `NavigationStack` in the app entry point. `SavedTimesView` is pushed via `NavigationLink` inside `ContentView`'s custom navbar rectangle.

**Theme system**: `AppTheme` holds two hex color strings (`background`, `accent`) plus a `usesDarkText: Bool`. `ThemeManager.nextTheme()` cycles `currentThemeIndex` through 6 hardcoded themes. `Color(hex:)` in `ColorExtensions.swift` parses these hex strings at render time.

**Timer mechanics**: A `Timer.scheduledTimer` fires every second to decrement `remainingSeconds`. A separate `withAnimation(.linear(duration:))` drives `progress` (0→1) for the circular `trim` indicator. Completion is handled via `DispatchQueue.main.asyncAfter` matching the animation duration — these two timers are not synchronized, only approximately aligned.

**Audio**: `SoundManager` is a singleton using `AVAudioPlayer`. The audio session (`.playback`, `.mixWithOthers`) is configured at app launch in `timer_appApp.init()`.

## iOS Design Target

The app targets iOS 16.0+ but the design direction is iOS 26 Liquid Glass / glassmorphism aesthetic — translucent layered materials, soft blur effects, minimal hard borders.
