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
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            MetronomeView()
                .tabItem {
                    Image(systemName: "metronome.fill")
                    Text("Metronome")
                }
            
            TunerView()
                .tabItem {
                    Image(systemName: "tuningfork")
                    Text("Tuner")
                }
            
            PracticeLogView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Practice Log")
                }
            
            AIChatbotView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("AI Chatbot")
                }
            
            SheetMusicLibraryView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Sheet Music Library")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
