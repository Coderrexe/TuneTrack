//
//  ContentView.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 26/09/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MetronomeView()
                .tabItem {
                    Image(systemName: "metronome")
                    Text("Metronome")
                }
            
            TunerView()
                .tabItem {
                    Image(systemName: "tuningfork")
                    Text("Tuner")
                }
            
            PracticeLogView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Practice")
                }
            
            AIChatbotView()
                .tabItem {
                    Image(systemName: "message")
                    Text("AI")
                }
            
            SheetMusicLibraryView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Library")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
