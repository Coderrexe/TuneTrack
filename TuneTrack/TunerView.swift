import SwiftUI
import AVFoundation

struct TunerView: View {
    @State private var isTuning = false
    @State private var frequency: Double = 440.0
    @State private var nearestNote = "A4"
    @State private var centsOff = 0.0
    @State private var frequencyHistory: [Double] = []
    @State private var baseFrequency: Double = 440.0
    
    let audioEngine = AVAudioEngine()
    let pitchNode = AVAudioUnitTimePitch()

    func startTuner() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
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
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            updateFrequencyReading()
        }
    }

    func stopTuner() {
        audioEngine.stop()
    }

    func updateFrequencyReading() {
        frequency = baseFrequency + Double.random(in: -5...5)
        frequencyHistory.append(frequency)
        if frequencyHistory.count > 50 { frequencyHistory.removeFirst() } // Limit history to last 50 readings
        
        let (note, deviation) = calculateNearestNoteAndCents(for: frequency)
        nearestNote = note
        centsOff = deviation
    }

    func calculateNearestNoteAndCents(for frequency: Double) -> (String, Double) {
        let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let a4Frequency = baseFrequency
        let semitoneRatio = pow(2.0, 1.0 / 12.0)
        
        let noteIndex = Int(round(12 * log2(frequency / a4Frequency))) + 9
        let octave = noteIndex / 12
        let note = notes[noteIndex % 12]
        
        let nearestFrequency = a4Frequency * pow(semitoneRatio, Double(noteIndex - 9))
        let centsDeviation = 1200 * log2(frequency / nearestFrequency)
        
        return ("\(note)\(octave)", centsDeviation)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Frequency: \(frequency, specifier: "%.2f") Hz")
                .font(.title)
            Text("Note: \(nearestNote)")
                .font(.title2)
            
            HStack {
                Text("Flat").foregroundColor(.red)
                Slider(value: $centsOff, in: -50...50, step: 0.1)
                    .accentColor(centsOff == 0 ? .green : .orange)
                    .disabled(true)
                Text("Sharp").foregroundColor(.red)
            }
            .padding(.horizontal)
            
            Text(centsOff == 0 ? "In Tune" : (centsOff > 0 ? "Sharp" : "Flat"))
                .foregroundColor(centsOff == 0 ? .green : .red)
                .font(.headline)
            
            LineGraph(data: frequencyHistory)
                .stroke(Color.blue, lineWidth: 2)
                .frame(height: 100)
                .padding(.horizontal)
                .overlay(Text("Frequency History").font(.caption).foregroundColor(.gray), alignment: .topLeading)

            VStack {
                HStack {
                    Text("Base Frequency: \(Int(baseFrequency)) Hz")
                    Slider(value: $baseFrequency, in: 430...450, step: 1)
                }
            }
            .padding(.horizontal)
            
            Button(isTuning ? "Stop Tuner" : "Start Tuner") {
                isTuning.toggle()
                if isTuning {
                    startTuner()
                } else {
                    stopTuner()
                }
            }
            .padding()
            .background(isTuning ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Tuner")
        .onDisappear {
            stopTuner()
        }
    }
}

struct LineGraph: Shape {
    var data: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard !data.isEmpty else { return path }
        
        let minY = data.min() ?? 0
        let maxY = data.max() ?? 1
        let yScale = rect.height / CGFloat(maxY - minY)
        
        let points = data.enumerated().map { index, value in
            CGPoint(x: CGFloat(index) / CGFloat(data.count - 1) * rect.width,
                    y: rect.height - (CGFloat(value - minY) * yScale))
        }
        
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        return path
    }
}
