//
//  repbarApp.swift
//  repbar
//
//  Created by Jack Harrington on 06/07/2025.
//

import SwiftUI
import UserNotifications

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var interval: Double  // seconds

    var displayInterval: String {
        "\(name) - \(interval)s"
    }
}

@main
struct SimpleReminderApp: App {
    @State private var timer: Timer?
    @State private var isRunning = false
    @State private var remainingTime: Double = 0
    @State private var clickedExercise: Exercise?

    @State var test_exercises = [
        Exercise(name: "Squat", interval: 10),
        Exercise(name: "Push Ups", interval: 60),
    ]

    init() {
        setupNotifications()
    }

    var body: some Scene {
        MenuBarExtra("Exercise Reminder", systemImage: "figure.cooldown") {
            MenuContent(
                timer: $timer,
                isRunning: $isRunning,
                exercises: $test_exercises,
                remainingTime: $remainingTime,
                currentExercise: $clickedExercise,
                toggleTimer: toggleTimer,
                showReminder: showReminder
            )
        }
        .menuBarExtraStyle(.window)
    }

    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("Permission granted: \(granted)")
            if let error = error {
                print("Permission error: \(error)")
            } else {
                print("Permission request completed successfully")
            }
        }
    }
    
    private func toggleTimer(interval: Double) {
        remainingTime = interval

        if timer != nil {
            // Stop timer
            timer?.invalidate()
            timer = nil
            isRunning = false
            print("Timer stopped")
        } else {
            // Start timer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in

                remainingTime -= 1

                if remainingTime <= 0 {
                    showReminder()
                    isRunning = false
                    timer?.invalidate()
                    timer = nil
                }
            }
            isRunning = true
        }
    }

    private func showReminder() {
        print("Showing reminder notification")

        let content = UNMutableNotificationContent()
        content.title = "Exercise Time! 🏃‍♂️"
        if let exercise = clickedExercise {
            content.body = "Time to do \(exercise.name)!"
        } else {
            content.body = "Time to exercise!"
        }
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            } else {
                print("Notification sent successfully")
            }
        }
    }
}

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

            Text("\(Int(remainingTime))s")

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

#Preview {
    @State @Previewable var timer: Timer?
    @State @Previewable var isRunning = false
    @State @Previewable var remainingTime: Double = 0
    @State @Previewable var currentExercise: Exercise?
    @State @Previewable var test_exercises = [
        Exercise(name: "Squat", interval: 10),
        Exercise(name: "Push Ups", interval: 60),
    ]

    MenuContent(
        timer: $timer,
        isRunning: $isRunning,
        exercises: $test_exercises,
        remainingTime: $remainingTime,
        currentExercise: $currentExercise,
        toggleTimer: { duration in
            print("Preview: Toggle timer with duration: \(duration)")
        },
        showReminder: {
            print("Preview: Show reminder")
        }
    )
}
