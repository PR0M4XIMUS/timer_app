# Timer App

A beautiful and intuitive SwiftUI timer application with customizable themes, saved timers, and audio notifications.

## Features

### ⏱️ Core Timer Functionality
- **Precise Time Setting**: Set timers using intuitive wheel pickers for hours (0-23), minutes (0-59), and seconds (0-59)
- **Visual Countdown**: Beautiful circular progress indicator that visually shows timer progress
- **Real-time Display**: Live countdown display in HH:MM:SS format
- **Audio Notification**: Plays alarm sound when timer completes
- **Start/Reset Control**: Single button that toggles between Start and Reset functionality

### 🎨 Theme System
- **6 Beautiful Themes**: Cycle through 6 carefully crafted color combinations
- **Dynamic Colors**: Each theme includes background, accent, and appropriate text colors
- **One-Tap Theme Switching**: Change themes instantly with the paintbrush button
- **Automatic Text Contrast**: Text color automatically adjusts for optimal readability

### 💾 Timer Management
- **Save Frequently Used Timers**: Automatically saves timer durations when started
- **Recently Used Section**: Quick access to your 3 most recent timer durations
- **Saved Times Library**: View and manage all your saved timer presets
- **Quick Selection**: Tap any saved time to instantly set it as your current timer
- **Delete Functionality**: Remove unwanted saved times with animated deletion

## Requirements

- **iOS**: 16.0 or later
- **Xcode**: 14.0 or later
- **Swift**: 5.7 or later
- **Device**: iPhone or iPad

## Setup and Installation

### Prerequisites
1. Install [Xcode](https://developer.apple.com/xcode/) from the Mac App Store
2. Ensure you have macOS 12.5 or later to run Xcode 14+

### Building the App
1. **Clone the Repository**
   ```bash
   git clone https://github.com/PR0M4XIMUS/timer_app.git
   cd timer_app
   ```

2. **Open in Xcode**
   ```bash
   open timer_app.xcodeproj
   ```

3. **Select Target Device**
   - Choose your target device or simulator from the device picker in Xcode
   - The app supports both iPhone and iPad

4. **Build and Run**
   - Press `⌘+R` or click the Play button in Xcode
   - The app will build and launch on your selected device/simulator

## User Interface and Controls

### Main Timer Screen

#### Navigation Bar
- **Timer Title**: Displays the app name
- **Theme Button** (🖌️): Tap to cycle through the 6 available themes
- **Saved Times Button** (🕐): Navigate to your saved and recently used timers

#### Timer Display
- **Circular Progress**: Large circle that fills clockwise as the timer runs
- **Time Display**: Shows current countdown time or selected time in HH:MM:SS format
- **Progress Animation**: Smooth circular animation with black stroke overlay

#### Time Selection
- **Hour Picker**: Wheel picker for hours (0h - 23h)
- **Minute Picker**: Wheel picker for minutes (0m - 59m)
- **Second Picker**: Wheel picker for seconds (0s - 59s)

#### Controls
- **Start Button**: Begins the timer with the selected duration
  - Automatically saves the time to your saved times list
  - Adds the time to recently used (max 3 items)
  - Only activates if time is not 00:00:00
- **Reset Button**: Stops the current timer and resets progress (appears when timer is running)

### Saved Times Screen

#### Recently Used Section
- Displays your 3 most recently used timer durations
- **Select Button** (➡️): Tap green arrow to select and return to main screen
- Automatically updated each time you start a timer

#### All Saved Times Section
- Complete list of all saved timer durations
- **Delete Button** (🗑️): Tap red trash icon to remove saved times with animation
- **Select Button** (➡️): Tap green arrow to select and return to main screen
- Scrollable list for managing many saved times

## App Architecture

### Core Components

#### `ContentView.swift`
The main timer interface containing:
- Timer state management (`selectedHour`, `selectedMinute`, `selectedSecond`)
- Animation and progress tracking (`progress`, `isAnimating`, `remainingSeconds`)
- Timer lifecycle management using `Timer.scheduledTimer`
- UI layout with theme integration

#### `SavedTimesView.swift`
Secondary view for timer management:
- Saved times display and management
- Recently used times tracking
- Time selection and deletion functionality
- Navigation back to main timer view

#### `ThemeManager.swift`
Centralized theme management:
- `AppTheme` struct defining color combinations
- 6 predefined themes with background, accent, and text colors
- `ObservableObject` for reactive UI updates
- Automatic text contrast based on theme

#### `SoundManager.swift`
Audio functionality:
- Singleton pattern for app-wide audio management
- `AVAudioPlayer` integration for alarm playback
- Error handling for missing sound files

#### `ColorExtensions.swift`
Utility for color management:
- SwiftUI `Color` extension for hex string parsing
- Robust hex color validation and error handling

### Audio System
- **AVFoundation Integration**: Proper audio session configuration
- **Background Audio**: Configured to mix with other apps' audio
- **Sound Files**: Includes `alarm.mp3` for timer completion notification

## Theme System

The app includes 6 beautiful themes that can be cycled through:

1. **Sophisticated Gray**: Light gray background with cream accent
2. **Ocean Blue**: Blue background with teal accent
3. **Bold Red**: Red background with dark gray accent
4. **Royal Purple**: Purple background with bright purple accent
5. **Slate Blue**: Dark blue background with cyan accent
6. **Warm Coral**: Coral background with turquoise accent

Each theme automatically adjusts text color (black or white) for optimal readability.

## Contributing

We welcome contributions! Please follow these guidelines:

### Getting Started
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the setup instructions above

### Code Style
- Follow Swift naming conventions
- Use SwiftUI best practices
- Maintain consistent indentation (4 spaces)
- Add comments for complex logic
- Use meaningful variable and function names

### Making Changes
1. **Small, Focused Changes**: Keep pull requests focused on a single feature or bug fix
2. **Test Your Changes**: Build and test on both iPhone and iPad simulators
3. **Theme Compatibility**: Ensure new UI elements work with all 6 themes
4. **Audio Considerations**: Test audio functionality and background behavior

### Submitting Changes
1. Commit your changes (`git commit -m 'Add amazing feature'`)
2. Push to your branch (`git push origin feature/amazing-feature`)
3. Open a Pull Request with a clear description of your changes

### Areas for Contribution
- **New Themes**: Add additional color themes to the ThemeManager
- **Sound Options**: Multiple alarm sound choices
- **Timer Presets**: Additional common timer durations
- **Accessibility**: VoiceOver and accessibility improvements
- **iPad Optimization**: Enhanced iPad layout and features
- **Complications**: Apple Watch complications support
- **Widgets**: iOS home screen widgets
- **Notification**: Background timer notifications

### Code Organization
- Place UI components in appropriate View files
- Use the existing ThemeManager for consistent styling
- Follow the established binding pattern for data flow
- Maintain the existing architecture patterns

### Testing Guidelines
- Test on multiple iOS versions (16.0+)
- Verify theme switching works correctly
- Test audio playback in various scenarios
- Ensure saved times persist correctly
- Test timer accuracy and completion behavior

## File Structure

```
timer_app/
├── timer_app/
│   ├── timer_appApp.swift          # App entry point and audio configuration
│   ├── ContentView.swift           # Main timer interface
│   ├── SavedTimesView.swift        # Saved times management view
│   ├── ThemeManager.swift          # Theme system and color management
│   ├── SoundManager.swift          # Audio playback functionality
│   ├── ColorExtensions.swift       # SwiftUI Color hex parsing extension
│   ├── Assets.xcassets/            # App icons and image assets
│   ├── Sounds/
│   │   └── alarm.mp3              # Timer completion sound
│   └── Preview Content/            # SwiftUI preview assets
├── timer_app.xcodeproj/           # Xcode project configuration
└── README.md                      # This documentation
```

## License

This project is available under the MIT License. See the LICENSE file for more details.

## Support

If you encounter any issues or have questions:
1. Check the existing issues in this repository
2. Create a new issue with detailed information about the problem
3. Include your iOS version, device model, and steps to reproduce

---

**Enjoy your perfectly timed productivity! ⏰✨**