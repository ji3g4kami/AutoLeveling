//
//  AudioAnalyst.swift
//  AutoLeveling
//
//  Created by 登秝吳 on 22/07/2021.
//

import AVFoundation

struct AudioAnalyst {
    enum AudioError: Error {
        case fileConversion
        case bufferConversion
    }
    
    let url: URL
    
    func getSamples() throws -> [Float] {
        let file: AVAudioFile
        do {
            file = try AVAudioFile(forReading: url)
        } catch {
            throw AudioError.fileConversion
        }
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length)) else {
            throw AudioError.bufferConversion
        }
        do {
            try file.read(into: buffer)
        } catch {
            throw error
        }
        let floatArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData?.pointee, count:Int(buffer.frameLength)))
        return floatArray
    }
    
    
    func autoLeveling(_ samples: [Float], targetdB: Float) -> Float {
        // Step 3. get current peak loudness, as signal magnitude
        let absArray = samples.map { abs($0) }
        let amplitude = absArray.max()
        // Step 4: compute required_multiplier to achieve target_magnitude:
        // target_loudness_db = -4 # for example --- will be given by producers
        // target_magnitude = 10.0 **( target_loudness_db/20)
        let targetMagnitude = pow(10, targetdB/20.0)
        let multiplier = targetMagnitude / amplitude!
        let dB = 20*log10(multiplier)
        return dB
    }
}
