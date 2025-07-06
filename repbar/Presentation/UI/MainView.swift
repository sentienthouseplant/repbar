//
//  MainView.swift
//  repbar
//
//  Created by Jack Harrington on 06/07/2025.
//
import SwiftUI

struct MenuContent: View {
    @Binding var timer: Timer?
    @Binding var isRunning: Bool
    @Binding var exercises: [Exercise]
    @Binding var remainingTime: Double
    @Binding var currentExercise: Exercise?
    let toggleTimer: (Double) -> Void
    let showReminder: () -> Void

    @State private var newExerciseName = "Test"
    @State private var newExerciseInterval = 300  // Default value

    var body: some View {
        VStack(alignment: .leading) {

            Text("\(Int(remainingTime/60)) Minutes")

            ForEach(exercises) {
                exercise in
                Button("\(exercise.displayInterval)") {
                    currentExercise = exercise
                    toggleTimer(exercise.interval)
                }
            }

            Divider()

            Button("🔔 Test Notification") {
                showReminder()
            }
            .keyboardShortcut("t")

            Divider()

            HStack {

                TextField("Exercise Name", text: $newExerciseName)

                Stepper(value: $newExerciseInterval, step: 60) {
                    Text("\(newExerciseInterval/60) Minutes")
                }

                Button("Add Exercise") {
                    exercises.append(
                        Exercise(name: newExerciseName, interval: Double(newExerciseInterval))
                    )
                }

            }

            Button("Quit") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}
