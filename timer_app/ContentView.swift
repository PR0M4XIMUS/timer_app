import SwiftUI

struct ContentView: View {
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedSecond = 0

    let hours = Array(0..<24) // For hours (0 to 23)
    let minutesAndSeconds = Array(0..<60) // For minutes and seconds (0 to 59)

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
                                
                                NavigationLink(destination: SavedTimesView()) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                        )
                    
                    Spacer()
                    
                    // Circle for Timer and Time Selection
                    ZStack {
                        Circle()
                            .stroke(Color(hex: "#333C45"), lineWidth: 13)
                            .frame(width: 350, height: 350)
                        
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
                            print("Clicked Start")
                        }) {
                            Rectangle()
                                .fill(Color(hex: "#333C45"))
                                .frame(width: 125, height: 45)
                                .cornerRadius(10)
                                .overlay(
                                    Text("Start")
                                        .foregroundColor(.white) // White text for the button
                                        .font(.headline)
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
