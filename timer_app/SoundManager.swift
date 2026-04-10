import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playSound(soundName: String, soundExtension: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: soundExtension) else {
            print("Error: Sound file '\(soundName).\(soundExtension)' not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
