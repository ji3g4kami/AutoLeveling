//
//  Recorder.swift
//  AutoLeveling
//
//  Created by 登秝吳 on 22/07/2021.
//

import Combine
import SwiftUI
import AVFoundation

let tempURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("temp.m4a")

final class Recorder: ObservableObject {
    enum State {
        case stop
        case record
    }
    
    @Published var state: State = .stop
    var cancellables = Set<AnyCancellable>()
    var audioRecorder: AVAudioRecorder!
    
    init() {
        print(tempURL)
        $state
            .dropFirst()
            .sink { [unowned self] state in
                switch state {
                case .record:
                    self.record()
                case .stop:
                    self.stop()
                }
            }
            .store(in: &cancellables)
    }
    
    func record() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: tempURL, settings: settings)
        } catch {
            print("Failed instantiating recorder", error)
        }
        
        audioRecorder.record()
    }
    
    func stop() {
        audioRecorder.stop()
        audioRecorder = nil
    }
}

