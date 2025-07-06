//
//  Exercise.swift
//  repbar
//
//  Created by Jack Harrington on 06/07/2025.
//
import Foundation

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var interval: Double  // seconds

    var displayInterval: String {
        "\(name) - \(interval/60) Minutes"
    }
}
