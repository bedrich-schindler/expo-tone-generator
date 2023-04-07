import ExpoModulesCore
import AVFoundation

public class ToneGenerator {
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var buffer: AVAudioPCMBuffer?
    private var frameLength: AVAudioFrameCount = 0
    private var isPlaying: Bool = false

    public func getIsPlaying() -> Bool {
        return isPlaying
    }

    public func play(frequency: Double) {
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 11025.0, channels: 1),
        let buffer = createBuffer(frequency: frequency, format: format) else {
            fatalError("Unable to create AVAudioFormat or AVAudioPCMBuffer objects")
        }

        self.buffer = buffer

        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: format)

        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        do {
            try audioEngine.start()
            playerNode.play()
            isPlaying = true;
        } catch {
            fatalError("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }

    public func stop() {
        playerNode.stop()
        audioEngine.stop()
        isPlaying = false;
    }

    public func setFrequency(frequency: Double) {
        guard let format = buffer?.format,
        let buffer = createBuffer(frequency: frequency, format: format) else {
            fatalError("Unable to create AVAudioPCMBuffer object")
        }

        self.buffer = buffer
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        playerNode.play()
    }

    private func createBuffer(frequency: Double, format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let sampleRate = format.sampleRate
        frameLength = AVAudioFrameCount(sampleRate / frequency)

        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameLength) else {
            return nil
        }

        guard let floatChannelData = buffer.floatChannelData else {
            return nil
        }

        for frame in 0..<Int(frameLength) {
            let time = Double(frame) / sampleRate
            floatChannelData[0][frame] = Float32(sin(2.0 * Double.pi * frequency * time))
        }

        buffer.frameLength = frameLength

        return buffer
    }
}

public class ToneGeneratorModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ToneGenerator")

    let toneGenerator = ToneGenerator()

    Function("getIsPlaying") { () in
        return toneGenerator.getIsPlaying()
    }

    AsyncFunction("play") { (frequency: Double) in
        toneGenerator.play(frequency: frequency)
    }

    AsyncFunction("stop") { () in
      toneGenerator.stop()
    }

    AsyncFunction("setFrequency") { (frequency: Double) in
      toneGenerator.setFrequency(frequency: frequency)
    }
  }
}

