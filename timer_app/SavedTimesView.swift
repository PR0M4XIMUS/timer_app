import SwiftUI

struct SavedTimesView: View {
    @Binding var savedTimes: [String] // Bind the saved times from ContentView
    @Binding var currentTime: String // Bind the current time from ContentView
    
    // Access the theme manager from the environment
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var selectedTime = "" // To store the selected time from the list
    
    // Track items being removed for animation
    @State private var itemsBeingRemoved = Set<String>()

    var body: some View {
        ZStack {
            themeManager.accentColor.ignoresSafeArea() // Background color using current theme

            // Add ScrollView to allow scrolling through many saved times
            ScrollView {
                VStack(spacing: 20) { // Vertical stack with spacing between items
                    ForEach(savedTimes, id: \.self) { time in
                        HStack {
                            Text(time)
                                .foregroundColor(themeManager.textColor)
                                .padding()
                                .frame(maxWidth: .infinity) // Make the rectangle wide
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
                                        savedTimes.remove(at: index) // Delete the rectangle
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
                            
                            // Green Button (Removed functionality)
                            Button(action: {
                                // No functionality for the green button anymore
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
                .padding()
                .animation(.easeInOut, value: savedTimes)
            }
            .navigationTitle("Saved Times")
            .foregroundColor(themeManager.textColor) // For the navigation title
        }
    }
}

#Preview {
    NavigationStack {
        SavedTimesView(savedTimes: .constant(["Time 1", "Time 2"]), currentTime: .constant("00:00:00"))
            .environmentObject(ThemeManager())
    }
}
