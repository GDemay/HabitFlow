//
//  Habit.swift
//  HabitFlow
//
//  Created by Guillaume Demay on 07.09.24.
//

import Foundation

enum HabitFrequency: String, Codable, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case custom = "Custom"

    var id: String { self.rawValue }
}

import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var isCompleted: Bool
    var streak: Int
    var lastUpdated: Date?
    var goal: String?
    var deadline: Date?
    var notes: String?
    var priority: String
    var frequency: HabitFrequency
    var totalCompletions: Int = 0
    var completionDates: [Date] = [] // New field to store completion dates
    
    // Custom initializer
    init(id: UUID = UUID(), name: String, isCompleted: Bool = false, streak: Int = 0, lastUpdated: Date? = nil, goal: String? = nil, deadline: Date? = nil, notes: String? = nil, priority: String = "Medium", frequency: HabitFrequency = .daily, totalCompletions: Int = 0, completionDates: [Date] = []) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
        self.streak = streak
        self.lastUpdated = lastUpdated
        self.goal = goal
        self.deadline = deadline
        self.notes = notes
        self.priority = priority
        self.frequency = frequency
        self.totalCompletions = totalCompletions
        self.completionDates = completionDates
    }
}
