import SwiftUI

struct SavedTimesView: View {
    @Binding var savedTimes: [String] // Bind the saved times from ContentView
    @Binding var currentTime: String // Bind the current time from ContentView

    @State private var selectedTime = "" // To store the selected time from the list

    var body: some View {
        ZStack {
            Color(hex: "#333C45").ignoresSafeArea() // Background color

            VStack(spacing: 20) { // Vertical stack with spacing between items
                ForEach(savedTimes, id: \.self) { time in
                    HStack {
                        Text(time)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // Make the rectangle wide
                            .background(Color(hex: "#D9535A"))
                            .cornerRadius(10)
                            

                        Spacer()

                        // Delete Button
                        Button(action: {
                            if let index = savedTimes.firstIndex(of: time) {
                                savedTimes.remove(at: index) // Delete the rectangle
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
                }
            }
            .padding()
            .navigationTitle("Saved Times")
        }
    }
}

#Preview {
    SavedTimesView(savedTimes: .constant(["Time 1", "Time 2", "Time 3", "Time 4"]), currentTime: .constant("00:00:00"))
}
