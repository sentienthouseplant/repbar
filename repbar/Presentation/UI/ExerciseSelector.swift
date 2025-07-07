//
//  ExerciseSelector.swift
//  repbar
//
//  Created by Jack Harrington on 07/07/2025.
//
import SwiftUI

struct ExerciseSelector: View {
    @Binding var exercise: Exercise
    
    var body: some View {
        HStack(spacing: 10){
            VStack{
                HStack(alignment: .center){
                    Text(exercise.name).font(.title)
                    Spacer()
                    Text("\(exercise.reps) Reps").bold()
                }
                HStack(alignment: .center){
                    Stepper("Every \(Int(exercise.interval/60)) Minutes", value: $exercise.interval, step: 60)
                    Spacer()
                    Toggle("", isOn : $exercise.active).toggleStyle(.switch)
                }
            }
        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(exercise.active ? Color.green : Color.gray, lineWidth: 2)
        )
    }
    
}

#Preview(traits: .fixedLayout(width: 300, height: 500)) {
    @Previewable @State var exercise = Exercise(name: "Exercise", interval: 300, reps: 10)
    ExerciseSelector(exercise: $exercise)
}
