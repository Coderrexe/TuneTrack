//
//  HomeView.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 12/09/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Metronome", destination: MetronomeView())
                NavigationLink("Tuner", destination: TunerView())
                NavigationLink("Practice Log", destination: PracticeLogView())
            }
            .navigationTitle("TuneTrack")
        }
    }
}

#Preview {
    HomeView()
}
