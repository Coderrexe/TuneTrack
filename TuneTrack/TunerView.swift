//
//  TunerView.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 12/09/2024.
//

import SwiftUI
import AVFoundation


struct TunerView: View {
    @State private var isTuning = false
    @State private var frequency: Double = 440.0 // in hertz

    let audioEngine = AVAudioEngine()
    let pitchNode = AVAudioUnitTimePitch()

    func startTuner() {
        // this is the audio engine
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        print("Sample rate: \(format.sampleRate), Channel count: \(format.channelCount)")
        
        // Ensure sample rate and channel count are valid
        guard format.sampleRate > 0 && format.channelCount > 0 else {
            print("Invalid audio format")
            return
        }

        audioEngine.attach(pitchNode)
        audioEngine.connect(inputNode, to: pitchNode, format: format)
        audioEngine.prepare()
    
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine boot failed")
        }
    }

    func stopTuner() {
        audioEngine.stop()
    }
    
    var body: some View {
        VStack {
            Text("Frequency: \(frequency, specifier: "%.2f") Hz")
                .font(.largeTitle)
            Text(frequency == 440 ? "In Tune" : "Tune Up or Down")
                .foregroundColor(frequency == 440 ? .green : .red)
            Button(isTuning ? "Stop Tuner" : "Start Tuner") {
                isTuning.toggle()
                if isTuning {
                    startTuner()
                } else {
                    stopTuner()
                }
            }
        }
        .padding()
        .navigationTitle("Tuner")
    }
}
