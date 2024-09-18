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
            
        }
        .padding()
        .navigationTitle("Tuner")
    }
}
