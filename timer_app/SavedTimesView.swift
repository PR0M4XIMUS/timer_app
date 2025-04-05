import SwiftUI

struct SavedTimesView: View {
    @Binding var savedTimes: [String] // Bind the saved times from ContentView
    @Binding var currentTime: String // Bind the current time from ContentView
    @Binding var recentlyUsedTimes: [String] // Bind recently used times
    @Binding var selectedHour: Int // Add binding for hour
    @Binding var selectedMinute: Int // Add binding for minute
    @Binding var selectedSecond: Int // Add binding for second
    
    // Environment variable to dismiss this view and return to ContentView
    @Environment(\.dismiss) private var dismiss
    
    // Access the theme manager from the environment
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var selectedTime = "" // To store the selected time from the list
    @State private var itemsBeingRemoved = Set<String>()
    
    // Function to parse time string and set values
    func selectTime(_ timeString: String) {
        // Parse the time string (format: "HH:MM:SS")
        let components = timeString.components(separatedBy: ":")
        if components.count == 3,
           let hours = Int(components[0]),
           let minutes = Int(components[1]),
           let seconds = Int(components[2]) {
            
            // Set the values in ContentView
            selectedHour = hours
            selectedMinute = minutes
            selectedSecond = seconds
            
            // Go back to ContentView
            dismiss()
        }
    }

    var body: some View {
        ZStack {
            themeManager.accentColor.ignoresSafeArea() // Background color using current theme

            // Add ScrollView to allow scrolling through many saved times
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Recently Used Section
                    if !recentlyUsedTimes.isEmpty {
                        Text("Recently Used")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal)
                        
                        ForEach(recentlyUsedTimes, id: \.self) { time in
                            HStack {
                                Text(time)
                                    .foregroundColor(themeManager.textColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(themeManager.backgroundColor)
                                    .cornerRadius(10)
                                    
                                Spacer()
                                
                                // Green Button with functionality
                                Button(action: {
                                    selectTime(time)
                                }) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .background(themeManager.textColor)
                            .padding(.vertical, 5)
                    }
                    
                    // All Saved Times Section
                    Text("All Saved Times")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        ForEach(savedTimes, id: \.self) { time in
                            HStack {
                                Text(time)
                                    .foregroundColor(themeManager.textColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(themeManager.backgroundColor)
                                    .cornerRadius(10)
                                    
                                Spacer()

                                // Delete Button
                                Button(action: {
                                    // Mark this item as being removed (for animation)
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        itemsBeingRemoved.insert(time)
                                    }
                                    
                                    // Delay actual removal to allow animation to complete
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        if let index = savedTimes.firstIndex(of: time) {
                                            savedTimes.remove(at: index)
                                        }
                                        // Also remove from recently used if it's there
                                        if let recentIndex = recentlyUsedTimes.firstIndex(of: time) {
                                            recentlyUsedTimes.remove(at: recentIndex)
                                        }
                                        itemsBeingRemoved.remove(time)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                                
                                // Green Button with functionality
                                Button(action: {
                                    selectTime(time)
                                }) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)
                            .opacity(itemsBeingRemoved.contains(time) ? 0 : 1)
                            .offset(x: itemsBeingRemoved.contains(time) ? 300 : 0)
                        }
                    }
                }
                .padding()
                .animation(.easeInOut, value: savedTimes)
            }
            .navigationTitle("Saved Times")
            .foregroundColor(themeManager.textColor)
        }
    }
}

#Preview {
    NavigationStack {
        SavedTimesView(
            savedTimes: .constant(["01:30:00", "00:45:00"]),
            currentTime: .constant("00:00:00"),
            recentlyUsedTimes: .constant(["00:15:00"]),
            selectedHour: .constant(0),
            selectedMinute: .constant(0),
            selectedSecond: .constant(0)
        )
        .environmentObject(ThemeManager())
    }
}
