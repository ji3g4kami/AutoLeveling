//
//  RecordView.swift
//  AutoLeveling
//
//  Created by 登秝吳 on 22/07/2021.
//

import SwiftUI
import Foundation

struct RecordView: View {
    @State private var recordFileExists = FileManager.default.fileExists(atPath: tempURL.path)
    @StateObject var recorder = Recorder()
    let player = AudioPlayer()
    
    var body: some View {
        VStack {
            ZStack {
                Button {
                    recorder.state = .record
                } label: {
                    VStack {
                        Image(systemName: "record.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fit)
                        Text("Tap to record")
                            .padding()
                    }
                    .foregroundColor(.red)
                }
                .opacity(recorder.state == .record ? 0 : 1)
                
                Button {
                    recorder.state = .stop
                    if FileManager.default.fileExists(atPath: tempURL.path) {
                        recordFileExists = true
                        player.setupAudio()
                    }
                } label: {
                    VStack {
                        Image(systemName: "stop.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fit)
                        Text(" Recording...")
                            .padding()
                    }
                    .foregroundColor(.red)
                }
                .opacity(recorder.state == .record ? 1 : 0)
            }
            
            Button {
                player.play()
            } label: {
                HStack {
                    Image(systemName: "play.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                    Text("Play recorded")
                        .padding()
                }
            }
            .opacity((recordFileExists && recorder.state == .stop) ? 1 : 0)

        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
