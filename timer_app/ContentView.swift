import SwiftUI

struct ContentView: View {
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedSecond = 0
    @State private var savedTimes = [String]() // List to store saved times
    @State private var currentTime = "00:00:00" // The current time for the timer
    @State private var progress: CGFloat = 0.0
    @State private var isAnimating = false
    @State private var remainingSeconds = 0 // Remaining seconds for countdown
    @State private var timer: Timer? = nil
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    let hours = Array(0..<24) // For hours (0 to 23)
    let minutesAndSeconds = Array(0..<60) // For minutes and seconds (0 to 59)
    var animationDuration: Double {
        return Double(selectedHour * 3600 + selectedMinute * 60 + selectedSecond) // Convert to total seconds
    }
    
    // Format remaining seconds to HH:MM:SS
    var formattedTime: String {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        ZStack {
            // Background Color - now using theme
            themeManager.backgroundColor.ignoresSafeArea()

            HStack {
                Spacer()
                VStack {
                    // Navbar with button
                    Rectangle()
                        .fill(themeManager.accentColor)
                        .frame(height: 40)
                        .cornerRadius(15)
                        .overlay(
                            HStack {
                                Text("Timer")
                                    .font(.headline)
                                    .foregroundColor(themeManager.textColor)
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: {
                                        themeManager.nextTheme() // Change to the next theme
                                    }) {
                                        Image(systemName: "paintbrush.pointed")
                                            .font(.system(size: 20))
                                            .foregroundColor(themeManager.textColor)
                                    }
                                    .padding()
                                    
                                    // In ContentView.swift, modify the NavigationLink:
                                    NavigationLink {
                                        SavedTimesView(savedTimes: $savedTimes, currentTime: $currentTime)
                                            .environmentObject(themeManager) // Explicitly pass the environment object
                                    } label: {
                                        Image(systemName: "clock")
                                            .font(.system(size: 20))
                                            .foregroundColor(themeManager.textColor)
                                    }

                                }
                            }
                            .padding(.horizontal)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 1.5)
                        )
                    
                    Spacer()
                    
                    // Circle for Timer and Time Selection
                    ZStack {
                        Circle()
                            .stroke(themeManager.accentColor, lineWidth: 13)
                            .frame(width: 350, height: 350)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 364, height: 364)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 336, height: 336)
                            )
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 13, lineCap: .round))
                            .frame(width: 350, height: 350)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            // Display the countdown timer or selected time
                            Text(isAnimating ? formattedTime : String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond))
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(themeManager.textColor) // Dynamic text color
                        }
                    }
                    .padding()
                    
                    // Time Picker: Hour, Minute, Second
                    HStack {
                        // Hour Picker
                        Picker("Hours", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)h")
                                    .foregroundColor(themeManager.textColor)
                            }
                        }
                        .frame(width: 80)
                        .pickerStyle(WheelPickerStyle())
                        
                        // Minute Picker
                        Picker("Minutes", selection: $selectedMinute) {
                            ForEach(minutesAndSeconds, id: \.self) { minute in
                                Text("\(minute)m")
                                    .foregroundColor(themeManager.textColor)
                            }
                        }
                        .frame(width: 80)
                        .pickerStyle(WheelPickerStyle())
                        
                        // Second Picker
                        Picker("Seconds", selection: $selectedSecond) {
                            ForEach(minutesAndSeconds, id: \.self) { second in
                                Text("\(second)s")
                                    .foregroundColor(themeManager.textColor)
                            }
                        }
                        .frame(width: 80)
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Start Button
                    VStack {
                        Button(action: {
                            let timeString = String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond)
                            if timeString != "00:00:00" {
                                savedTimes.append(timeString) // Save the time when it's not 00:00:00
                            }
                            if isAnimating {
                                isAnimating = false
                                progress = 0.0 // Reset instantly without animation
                                timer?.invalidate() // Stop the timer
                                timer = nil
                            } else {
                                isAnimating = true
                                // Set up the initial remaining seconds
                                remainingSeconds = selectedHour * 3600 + selectedMinute * 60 + selectedSecond
                                
                                // Start the circular progress animation
                                withAnimation(.linear(duration: animationDuration)) {
                                    progress = 1.0
                                }
                                
                                // Set up the timer to update the countdown every second
                                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                    if remainingSeconds > 0 {
                                        remainingSeconds -= 1
                                    } else {
                                        timer?.invalidate()
                                        timer = nil
                                    }
                                }
                                
                                // Automatically reset after animation completes
                                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                    progress = 0.0 // Reset instantly without animation
                                    isAnimating = false
                                    timer?.invalidate()
                                    timer = nil
                                }
                            }
                        }) {
                            Rectangle()
                                .fill(themeManager.accentColor)
                                .frame(width: 125, height: 45)
                                .cornerRadius(10)
                                .overlay(
                                    Text(isAnimating ? "Reset" : "Start")
                                        .foregroundColor(themeManager.textColor) // Dynamic text color
                                        .font(.headline)
                                )
                                .animation(.linear(duration: 0), value: progress) // Smooth animation
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10) // Match corner radius
                                        .stroke(Color.black, lineWidth: 1.5) // Black border
                                )
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environmentObject(ThemeManager())
    }
}

