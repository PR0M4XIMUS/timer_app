import SwiftUI

struct SavedTimesView: View {
    let savedTimes = ["Time 1", "Time 2", "Time 3"] // Example data

    var body: some View {
        List(savedTimes, id: \.self) { time in
            Text(time)
        }
        .navigationTitle("Saved Times")
    }
}

#Preview {
    SavedTimesView()
}
