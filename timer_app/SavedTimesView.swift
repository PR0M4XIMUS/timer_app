import SwiftUI

struct SavedTimesView: View {
    @Binding var savedTimes:        [String]
    @Binding var recentlyUsedTimes: [String]
    @Binding var selectedHour:      Int
    @Binding var selectedMinute:    Int
    @Binding var selectedSecond:    Int

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var itemsBeingRemoved = Set<String>()

    // MARK: - Actions

    func selectTime(_ timeString: String) {
        let parts = timeString.components(separatedBy: ":")
        guard parts.count == 3,
              let h = Int(parts[0]),
              let m = Int(parts[1]),
              let s = Int(parts[2]) else { return }
        selectedHour   = h
        selectedMinute = m
        selectedSecond = s
        dismiss()
    }

    func deleteTime(_ time: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            itemsBeingRemoved.insert(time)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(duration: 0.35)) {
                savedTimes.removeAll        { $0 == time }
                recentlyUsedTimes.removeAll { $0 == time }
            }
            itemsBeingRemoved.remove(time)
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            themeManager.backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.45), value: themeManager.currentThemeIndex)

            VStack(spacing: 0) {

                // MARK: Pill navbar (matches ContentView style)
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(themeManager.textColor)
                    }

                    Spacer()

                    Text("Saved Timers")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeManager.textColor)

                    Spacer()

                    // Mirror the back button width so the title stays centred
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .opacity(0)
                    .allowsHitTesting(false)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(themeManager.textColor.opacity(0.15), lineWidth: 0.5)
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // MARK: Content
                if savedTimes.isEmpty && recentlyUsedTimes.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "clock.badge.questionmark")
                            .font(.system(size: 52, weight: .thin))
                            .foregroundStyle(themeManager.textColor.opacity(0.35))
                        Text("No saved timers yet")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundStyle(themeManager.textColor.opacity(0.5))
                        Text("Start a timer and it will appear here")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundStyle(themeManager.textColor.opacity(0.3))
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 28) {

                            // Recently Used
                            if !recentlyUsedTimes.isEmpty {
                                SectionHeader(title: "Recently Used",
                                              textColor: themeManager.textColor)
                                VStack(spacing: 10) {
                                    ForEach(recentlyUsedTimes, id: \.self) { time in
                                        TimerRow(time: time,
                                                 textColor: themeManager.textColor,
                                                 showDelete: false,
                                                 onSelect: { selectTime(time) },
                                                 onDelete: {})
                                        .transition(.asymmetric(
                                            insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal:   .move(edge: .leading).combined(with: .opacity)
                                        ))
                                    }
                                }
                            }

                            // All Saved
                            if !savedTimes.isEmpty {
                                SectionHeader(title: "All Saved",
                                              textColor: themeManager.textColor)
                                VStack(spacing: 10) {
                                    ForEach(savedTimes, id: \.self) { time in
                                        TimerRow(time: time,
                                                 textColor: themeManager.textColor,
                                                 showDelete: true,
                                                 onSelect: { selectTime(time) },
                                                 onDelete: { deleteTime(time) })
                                        .opacity(itemsBeingRemoved.contains(time) ? 0 : 1)
                                        .offset(x:  itemsBeingRemoved.contains(time) ? 60 : 0)
                                        .transition(.asymmetric(
                                            insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal:   .move(edge: .leading).combined(with: .opacity)
                                        ))
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .padding(.top, 4)
                        .animation(.spring(duration: 0.35), value: savedTimes)
                        .animation(.spring(duration: 0.35), value: recentlyUsedTimes)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .environment(\.colorScheme, themeManager.preferredColorScheme)
        .animation(.easeInOut(duration: 0.45), value: themeManager.currentThemeIndex)
    }
}

// MARK: - Section header

private struct SectionHeader: View {
    let title:     String
    let textColor: Color

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundStyle(textColor.opacity(0.5))
            .kerning(1.0)
            .padding(.horizontal, 4)
    }
}

// MARK: - Timer row

private struct TimerRow: View {
    let time:       String
    let textColor:  Color
    let showDelete: Bool
    let onSelect:   () -> Void
    let onDelete:   () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(time)
                .font(.system(size: 20, weight: .light, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            if showDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(textColor.opacity(0.65))
                        .frame(width: 36, height: 36)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }

            Button(action: onSelect) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(textColor)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle().strokeBorder(textColor.opacity(0.2), lineWidth: 0.5)
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
            savedTimes:        .constant(["01:30:00", "00:45:00", "00:05:00"]),
            recentlyUsedTimes: .constant(["00:15:00", "00:03:00"]),
            selectedHour:      .constant(0),
            selectedMinute:    .constant(0),
            selectedSecond:    .constant(0)
        )
        .environmentObject(ThemeManager())
    }
}
