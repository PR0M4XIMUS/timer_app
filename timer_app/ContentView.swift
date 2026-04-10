import SwiftUI
import UIKit

struct ContentView: View {
    // Persistence
    @AppStorage("savedTimesJSON") private var savedTimesJSON: String = "[]"
    @AppStorage("recentlyUsedJSON") private var recentlyUsedJSON: String = "[]"

    @State private var savedTimes: [String] = []
    @State private var recentlyUsedTimes: [String] = []
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedSecond = 0
    @State private var progress: CGFloat = 0.0
    @State private var isAnimating = false
    @State private var remainingSeconds = 0
    @State private var timer: Timer? = nil

    @EnvironmentObject private var themeManager: ThemeManager

    let hours = Array(0..<24)
    let minutesAndSeconds = Array(0..<60)

    var animationDuration: Double {
        Double(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
    }

    var formattedTime: String {
        let h = remainingSeconds / 3600
        let m = (remainingSeconds % 3600) / 60
        let s = remainingSeconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }

    var displayedTime: String {
        isAnimating
            ? formattedTime
            : String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond)
    }

    // MARK: - Persistence

    func loadFromStorage() {
        savedTimes = decode(savedTimesJSON)
        recentlyUsedTimes = decode(recentlyUsedJSON)
    }

    func saveToStorage() {
        savedTimesJSON = encode(savedTimes)
        recentlyUsedJSON = encode(recentlyUsedTimes)
    }

    private func decode(_ json: String) -> [String] {
        (try? JSONDecoder().decode([String].self, from: Data(json.utf8))) ?? []
    }

    private func encode(_ array: [String]) -> String {
        (try? String(data: JSONEncoder().encode(array), encoding: .utf8)) ?? "[]"
    }

    // MARK: - Haptics

    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    // MARK: - Timer Actions

    func startTimer() {
        let timeString = String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond)
        guard timeString != "00:00:00" else { return }

        haptic(.medium)

        if !savedTimes.contains(timeString) {
            savedTimes.append(timeString)
        }
        if let idx = recentlyUsedTimes.firstIndex(of: timeString) {
            recentlyUsedTimes.remove(at: idx)
        }
        recentlyUsedTimes.insert(timeString, at: 0)
        if recentlyUsedTimes.count > 3 { recentlyUsedTimes.removeLast() }
        saveToStorage()

        isAnimating = true
        remainingSeconds = selectedHour * 3600 + selectedMinute * 60 + selectedSecond

        withAnimation(.linear(duration: animationDuration)) {
            progress = 1.0
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                timer?.invalidate()
                timer = nil
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            guard isAnimating else { return }
            isAnimating = false
            withAnimation(.smooth(duration: 0.8)) { progress = 0 }
            timer?.invalidate()
            timer = nil
            SoundManager.shared.playSound(soundName: "alarm", soundExtension: "mp3")
        }
    }

    func resetTimer() {
        haptic(.medium)
        isAnimating = false
        withAnimation(.easeOut(duration: 0.4)) { progress = 0.0 }
        timer?.invalidate()
        timer = nil
        SoundManager.shared.stopSound()
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            themeManager.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Floating Navbar
                HStack {
                    Text("Timer")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeManager.textColor)

                    Spacer()

                    HStack(spacing: 2) {
                        Button {
                            haptic(.light)
                            withAnimation(.spring(duration: 0.4)) {
                                themeManager.nextTheme()
                            }
                        } label: {
                            Image(systemName: "paintbrush.pointed.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(themeManager.textColor)
                                .frame(width: 38, height: 38)
                        }

                        NavigationLink {
                            SavedTimesView(
                                savedTimes: $savedTimes,
                                recentlyUsedTimes: $recentlyUsedTimes,
                                selectedHour: $selectedHour,
                                selectedMinute: $selectedMinute,
                                selectedSecond: $selectedSecond
                            )
                            .environmentObject(themeManager)
                        } label: {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(themeManager.textColor)
                                .frame(width: 38, height: 38)
                        }
                    }
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

                Spacer()

                // MARK: Progress Ring
                ZStack {
                    // Track
                    Circle()
                        .stroke(themeManager.textColor.opacity(0.13), lineWidth: 15)
                        .frame(width: 290, height: 290)

                    // Progress arc
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            themeManager.textColor.opacity(0.9),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .frame(width: 290, height: 290)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: themeManager.textColor.opacity(0.25), radius: 8, x: 0, y: 0)

                    // Time label
                    Text(displayedTime)
                        .font(.system(size: 48, weight: .thin, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(themeManager.textColor)
                        .contentTransition(.numericText())
                        .animation(.default, value: remainingSeconds)
                }
                .padding(.vertical, 20)

                // MARK: Pickers
                HStack(spacing: 0) {
                    Picker("Hours", selection: $selectedHour) {
                        ForEach(hours, id: \.self) { Text("\($0)h").tag($0) }
                    }
                    .frame(maxWidth: .infinity)
                    .pickerStyle(.wheel)
                    .disabled(isAnimating)

                    Picker("Minutes", selection: $selectedMinute) {
                        ForEach(minutesAndSeconds, id: \.self) { Text("\($0)m").tag($0) }
                    }
                    .frame(maxWidth: .infinity)
                    .pickerStyle(.wheel)
                    .disabled(isAnimating)

                    Picker("Seconds", selection: $selectedSecond) {
                        ForEach(minutesAndSeconds, id: \.self) { Text("\($0)s").tag($0) }
                    }
                    .frame(maxWidth: .infinity)
                    .pickerStyle(.wheel)
                    .disabled(isAnimating)
                }
                .frame(height: 150)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(themeManager.textColor.opacity(0.12), lineWidth: 0.5)
                )
                .padding(.horizontal, 16)

                Spacer()

                // MARK: Start / Reset Button
                Button {
                    isAnimating ? resetTimer() : startTimer()
                } label: {
                    Text(isAnimating ? "Reset" : "Start")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeManager.textColor)
                        .frame(width: 160, height: 54)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(themeManager.textColor.opacity(0.2), lineWidth: 0.5)
                        )
                }
                .padding(.bottom, 36)
            }
        }
        .environment(\.colorScheme, themeManager.preferredColorScheme)
        .onAppear(perform: loadFromStorage)
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environmentObject(ThemeManager())
    }
}
