import SwiftUI
import AVFoundation

struct MetronomeView: View {
    @State private var bpm: Double = 120
    @State private var isPlaying = false
    @State private var beatSubdivisions = 1
    @State private var metronomeVolume: Float = 0.5
    @State private var selectedSound = "bounce"
    @State private var timer: Timer?
    @State private var tapTimes: [Date] = []
    @State private var showPresetSaveAlert = false
    @State private var savedPresets: [Double] = [60, 120, 180]
    @State private var selectedPreset = 120.0

    private let sounds = ["bounce", "woodblock", "cowbell"]
    private let subdivisionOptions = [1, 2, 4, 8]
    
    func playMetronome() {
        stopMetronome()
        let interval = 60.0 / bpm / Double(beatSubdivisions)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            playClick()
        }
    }

    func stopMetronome() {
        timer?.invalidate()
        timer = nil
    }

    func playClick() {
        guard let url = Bundle.main.url(forResource: selectedSound, withExtension: "wav") else { return }
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.volume = metronomeVolume
        player?.play()
    }

    func tapTempo() {
        let now = Date()
        tapTimes.append(now)
        
        if tapTimes.count > 4 {
            tapTimes.removeFirst()
        }
        
        if tapTimes.count >= 2 {
            let intervals = zip(tapTimes.dropLast(), tapTimes.dropFirst()).map { $1.timeIntervalSince($0) }
            let averageInterval = intervals.reduce(0, +) / Double(intervals.count)
            bpm = 60.0 / averageInterval
        }
    }

    func savePreset() {
        if !savedPresets.contains(bpm) {
            savedPresets.append(bpm)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("BPM: \(Int(bpm))")
                .font(.largeTitle)
                .padding()
            
            Slider(value: $bpm, in: 40...240, step: 1)
                .padding(.horizontal)
            
            HStack {
                Button("-5") { bpm = max(40, bpm - 5) }
                Button("-1") { bpm = max(40, bpm - 1) }
                Button("+1") { bpm = min(240, bpm + 1) }
                Button("+5") { bpm = min(240, bpm + 5) }
            }
            
            Button(action: tapTempo) {
                Text("Tap Tempo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Picker("Beat Subdivisions", selection: $beatSubdivisions) {
                ForEach(subdivisionOptions, id: \.self) { subdivision in
                    Text("\(subdivision)x").tag(subdivision)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Picker("Click Sound", selection: $selectedSound) {
                ForEach(sounds, id: \.self) { sound in
                    Text(sound.capitalized)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
            
            HStack {
                Text("Volume")
                Slider(value: $metronomeVolume, in: 0...1)
            }
            .padding(.horizontal)
            
            Button(isPlaying ? "Stop" : "Start") {
                isPlaying.toggle()
                if isPlaying {
                    playMetronome()
                } else {
                    stopMetronome()
                }
            }
            .padding()
            .background(isPlaying ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Save Preset") {
                showPresetSaveAlert = true
                savePreset()
            }
            .alert(isPresented: $showPresetSaveAlert) {
                Alert(title: Text("Preset Saved"), message: Text("BPM \(Int(bpm)) has been added to presets."), dismissButton: .default(Text("OK")))
            }
            
            Picker("Load Preset", selection: $selectedPreset) {
                ForEach(savedPresets, id: \.self) { preset in
                    Text("\(Int(preset)) BPM").tag(preset)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedPreset) { newPreset in
                bpm = newPreset
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Metronome")
        .onDisappear {
            stopMetronome()
        }
    }
}
