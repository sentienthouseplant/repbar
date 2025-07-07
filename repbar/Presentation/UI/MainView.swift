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

            ForEach($exercises) {
                $exercise in
                ExerciseSelector(exercise: $exercise).padding()
            }

            Divider()

            Button("Quit") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q")
        }.background(Color.white)
    }
}
