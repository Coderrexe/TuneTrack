//
//  MetronomeView.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 12/09/2024.
//

import SwiftUI
import AVFoundation

struct MetronomeView: View {
    @State private var bpm: Double = 120
    @State private var isPlaying = false

    func playMetronome() {
        let interval = 60.0 / bpm
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if !isPlaying {
                timer.invalidate()
            } else {
                playClick()
            }
        }
    }

    func playClick() {
        guard let url = Bundle.main.url(forResource: "asdf", withExtension: "mp3") else { return }
        let player = AVPlayer(url: url)
        player.play()
    }

    var body: some View {
        VStack {
            Slider(value: $bpm, in: 40...240, step: 1)
            Text("BPM: \(Int(bpm))")
            Button(isPlaying ? "Stop" : "Start") {
                isPlaying.toggle()
                if isPlaying {
                    playMetronome()
                }
            }
        }
        .padding()
        .navigationTitle("Metronome")
    }
}
