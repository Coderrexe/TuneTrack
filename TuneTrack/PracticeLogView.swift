//
//  PracticeLogView.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 12/09/2024.
//

import SwiftUI

struct PracticeLogView: View {
    @State private var practiceSessions: [(Date, Date)] = []
    @State private var isPracticing = false
    @State private var startTime = Date()

    func logPracticeSession() {
        let endTime = Date()
        practiceSessions.append((startTime, endTime))
    }

    var body: some View {
        VStack {
            if isPracticing {
                Text("Practicing...")
            } else {
                Text("Not Practicing")
            }

            Button(isPracticing ? "Stop Practice" : "Start Practice") {
                isPracticing.toggle()
                if isPracticing {
                    startTime = Date()
                } else {
                    logPracticeSession()
                }
            }

            List(practiceSessions, id: \.0) { session in
                Text("Start: \(session.0), End: \(session.1)")
            }
        }
        .padding()
        .navigationTitle("Practice Log")
    }
}
