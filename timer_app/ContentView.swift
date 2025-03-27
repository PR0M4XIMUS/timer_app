import SwiftUI

struct ContentView: View {
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedSecond = 0
    @State private var savedTimes = [String]() // List to store saved times
    @State private var currentTime = "00:00:00" // The current time for the timer
    @State private var progress: CGFloat = 0.0
    @State private var isAnimating = false

    let hours = Array(0..<24) // For hours (0 to 23)
    let minutesAndSeconds = Array(0..<60) // For minutes and seconds (0 to 59)
    var animationDuration: Double {
        return Double(selectedHour * 3600 + selectedMinute * 60 + selectedSecond) // Convert to total seconds
        }

    var body: some View {
        ZStack {
            // Background Color
            Color(hex: "#D9535A").ignoresSafeArea()

            HStack {
                Spacer()
                VStack {
                    // Navbar with button
                    Rectangle()
                        .fill(Color(hex: "#333C45"))
                        .frame(height: 40)
                        .cornerRadius(15)
                        .overlay(
                            HStack {
                                Text("Timer")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                NavigationLink(destination: SavedTimesView(savedTimes: $savedTimes, currentTime: $currentTime)) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                        )
                        .overlay(
                                RoundedRectangle(cornerRadius: 15) // Match corner radius
                                    .stroke(Color.black, lineWidth: 1.5) // Black border
                                )
                    Spacer()
                    
                    // Circle for Timer and Time Selection
                    ZStack {
                        Circle()
                            .stroke(Color(hex: "#333C45"), lineWidth: 13)
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
                            // Display the selected time in HH:MM:SS format
                            Text(String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond))
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(.white) // White text for the timer display
                        }
                    }
                    .padding()
                    
                    // Time Picker: Hour, Minute, Second
                    HStack {
                        // Hour Picker
                        Picker("Hours", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)h")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 80)
                        .pickerStyle(WheelPickerStyle())
                        
                        // Minute Picker
                        Picker("Minutes", selection: $selectedMinute) {
                            ForEach(minutesAndSeconds, id: \.self) { minute in
                                Text("\(minute)m")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 80)
                        .pickerStyle(WheelPickerStyle())
                        
                        // Second Picker
                        Picker("Seconds", selection: $selectedSecond) {
                            ForEach(minutesAndSeconds, id: \.self) { second in
                                Text("\(second)s")
                                    .foregroundColor(.white)
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
                            withAnimation(.linear(duration: animationDuration)) {
                                isAnimating.toggle()
                                progress = isAnimating ? 1.0 : 0.0  // Toggle animation
                            }
                            let timeString = String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond)
                            if timeString != "00:00:00" {
                                savedTimes.append(timeString) // Save the time when it's not 00:00:00
                            }
                        }) {
                            Rectangle()
                                .fill(Color(hex: "#333C45"))
                                .frame(width: 125, height: 45)
                                .cornerRadius(10)
                                .overlay(
                                    Text(isAnimating ? "Reset" : "Start")
                                        .foregroundColor(.white) // White text for the button
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
    ContentView()
}
