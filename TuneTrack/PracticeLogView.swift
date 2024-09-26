//
//  PracticeLogView.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 12/09/2024.
//

import SwiftUI

struct Goal: Identifiable {
    var id = UUID()
    var description: String
    var targetDate: Date
    var progress: Double
    var isCompleted: Bool {
        return progress >= 100
    }
}

struct PracticeLogView: View {
    @State private var practiceSessions: [(Date, Date)] = []
    @State private var goals: [Goal] = []
    @State private var newGoalDescription = ""
    @State private var newGoalTargetDate = Date()
    @State private var showAlert = false

    func logPracticeSession() {
        let endTime = Date()
        practiceSessions.append((Date(), endTime))
    }

    func addGoal() {
        if newGoalDescription.isEmpty {
            showAlert = true
        } else {
            let newGoal = Goal(description: newGoalDescription, targetDate: newGoalTargetDate, progress: 0)
            goals.append(newGoal)
            newGoalDescription = ""
        }
    }

    func updateGoalProgress(goal: Goal, progress: Double) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].progress = progress
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Practice Sessions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                if practiceSessions.isEmpty {
                    Text("No practice sessions recorded.")
                        .foregroundColor(.gray)
                } else {
                    List(practiceSessions, id: \.0) { session in
                        Text("Start: \(session.0, formatter: dateFormatter), End: \(session.1, formatter: dateFormatter)")
                    }
                    .frame(height: 200)
                }

                // Goal Setting Section
                Divider().padding(.vertical)

                Text("Set New Practice Goal")
                    .font(.title2)
                    .fontWeight(.bold)

                TextField("Enter goal description", text: $newGoalDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical)

                DatePicker("Target Date", selection: $newGoalTargetDate, displayedComponents: .date)
                    .padding(.vertical)

                Button(action: addGoal) {
                    Text("Add Goal")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Please enter a description"), message: Text("Goal description cannot be empty"), dismissButton: .default(Text("OK")))
                }

                if !goals.isEmpty {
                    Text("Practice Goals")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)

                    List(goals) { goal in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(goal.description)
                                    .font(.headline)
                                Spacer()
                                if goal.isCompleted {
                                    Text("Completed")
                                        .foregroundColor(.green)
                                } else {
                                    Text("In Progress")
                                        .foregroundColor(.orange)
                                }
                            }
                            Text("Target Date: \(goal.targetDate, formatter: dateFormatter)")
                                .foregroundColor(.gray)
                                .font(.subheadline)

                            ProgressView(value: goal.progress, total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: goal.isCompleted ? .green : .blue))
                                .padding(.vertical, 5)

                            if !goal.isCompleted {
                                HStack {
                                    Button(action: {
                                        let newProgress = min(goal.progress + 10, 100)
                                        updateGoalProgress(goal: goal, progress: newProgress)
                                    }) {
                                        Text("Mark 10% Progress")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }

                                    Spacer()

                                    Button(action: {
                                        updateGoalProgress(goal: goal, progress: 100)
                                    }) {
                                        Text("Mark as Completed")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .frame(height: 300)
                } else {
                    Text("No practice goals set.")
                        .foregroundColor(.gray)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Practice Log & Goals")
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
