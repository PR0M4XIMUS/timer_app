import SwiftUI

struct SavedTimesView: View {
    @Binding var savedTimes: [String]
    @Binding var recentlyUsedTimes: [String]
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    @Binding var selectedSecond: Int

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var itemsBeingRemoved = Set<String>()

    func selectTime(_ timeString: String) {
        let parts = timeString.components(separatedBy: ":")
        guard parts.count == 3,
              let h = Int(parts[0]),
              let m = Int(parts[1]),
              let s = Int(parts[2]) else { return }
        selectedHour = h
        selectedMinute = m
        selectedSecond = s
        dismiss()
    }

    func deleteTime(_ time: String) {
        withAnimation(.easeInOut(duration: 0.35)) {
            itemsBeingRemoved.insert(time)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            savedTimes.removeAll { $0 == time }
            recentlyUsedTimes.removeAll { $0 == time }
            itemsBeingRemoved.remove(time)
        }
    }

    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()

            Group {
                if savedTimes.isEmpty && recentlyUsedTimes.isEmpty {
                    // Empty state
                    VStack(spacing: 12) {
                        Image(systemName: "clock.badge.questionmark")
                            .font(.system(size: 48, weight: .thin))
                            .foregroundStyle(themeManager.textColor.opacity(0.4))
                        Text("No saved timers yet")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundStyle(themeManager.textColor.opacity(0.5))
                        Text("Start a timer to save it here")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundStyle(themeManager.textColor.opacity(0.35))
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {

                            // Recently Used
                            if !recentlyUsedTimes.isEmpty {
                                SectionHeader(title: "Recently Used", textColor: themeManager.textColor)

                                VStack(spacing: 10) {
                                    ForEach(recentlyUsedTimes, id: \.self) { time in
                                        TimerRow(
                                            time: time,
                                            textColor: themeManager.textColor,
                                            showDelete: false,
                                            onSelect: { selectTime(time) },
                                            onDelete: {}
                                        )
                                    }
                                }
                            }

                            // All Saved
                            if !savedTimes.isEmpty {
                                SectionHeader(title: "All Saved", textColor: themeManager.textColor)

                                VStack(spacing: 10) {
                                    ForEach(savedTimes, id: \.self) { time in
                                        TimerRow(
                                            time: time,
                                            textColor: themeManager.textColor,
                                            showDelete: true,
                                            onSelect: { selectTime(time) },
                                            onDelete: { deleteTime(time) }
                                        )
                                        .opacity(itemsBeingRemoved.contains(time) ? 0 : 1)
                                        .offset(x: itemsBeingRemoved.contains(time) ? 60 : 0)
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
        .navigationTitle("Saved Timers")
        .navigationBarTitleDisplayMode(.large)
        .environment(\.colorScheme, themeManager.preferredColorScheme)
    }
}

// MARK: - Sub-views

private struct SectionHeader: View {
    let title: String
    let textColor: Color

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(textColor.opacity(0.55))
            .kerning(0.8)
            .padding(.horizontal, 4)
    }
}

private struct TimerRow: View {
    let time: String
    let textColor: Color
    let showDelete: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(time)
                .font(.system(size: 18, weight: .light, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            if showDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(textColor.opacity(0.7))
                        .frame(width: 34, height: 34)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }

            Button(action: onSelect) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(textColor)
                    .frame(width: 34, height: 34)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(textColor.opacity(0.2), lineWidth: 0.5)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(textColor.opacity(0.1), lineWidth: 0.5)
        )
    }
}

#Preview {
    NavigationStack {
        SavedTimesView(
            savedTimes: .constant(["01:30:00", "00:45:00", "00:05:00"]),
            recentlyUsedTimes: .constant(["00:15:00"]),
            selectedHour: .constant(0),
            selectedMinute: .constant(0),
            selectedSecond: .constant(0)
        )
        .environmentObject(ThemeManager())
    }
}
