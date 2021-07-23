//
//  AudioPlayer.swift
//  AutoLeveling
//
//  Created by 登秝吳 on 22/07/2021.
//

import AVFoundation

final class AudioPlayer {
    
    private let dB: Float = {
        let audioAnalyst = AudioAnalyst(url: tempURL)
        do {
            let samples = try audioAnalyst.getSamples()
            let dB = audioAnalyst.autoLeveling(samples, targetdB: -3)
            print("dB", dB)
            return dB
        } catch {
            print("Sampling error", error)
            return 0
        }
    }()
    
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var audioFile: AVAudioFile!
    
    init() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("AVAudioSession Error", error)
        }
        setupAudio()
    }
    
    func setupAudio() {
        do {
            audioFile = try AVAudioFile(forReading: tempURL)
            let format = audioFile.processingFormat
            
            configureEngine(with: format)
        } catch {
            print("Error reading the audio file: \(error.localizedDescription)")
        }
    }
    
    private func configureEngine(with format: AVAudioFormat) {
        engine.attach(player)
        let eq = AVAudioUnitEQ()
        eq.globalGain = dB
        engine.attach(eq)
        
        engine.connect(eq, to: engine.mainMixerNode, format: format)
        engine.connect(player, to: eq, format: format)
        engine.prepare()
        
        do {
            try engine.start()
        } catch {
            print("Error starting the player: \(error.localizedDescription)")
        }
    }
    
    func play() {
        player.scheduleFile(audioFile, at: nil) {
            print("Complete")
        }
        player.play()
    }
}
