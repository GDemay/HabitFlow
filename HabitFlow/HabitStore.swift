import Foundation
import SwiftUI


class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var showingAddHabitForm = false
    @Published var showingEditHabitForm = false // Manage edit form visibility
    
    func loadHabits() {
        if let savedHabits = UserDefaults.standard.object(forKey: "habits") as? Data {
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: savedHabits) {
                habits = decodedHabits
            }
        }
    }
    
    func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "habits")
        }
    }
    
    // Function to add a new habit
    func addHabit(name: String, goal: String?, deadline: Date?, priority: String, notes: String?, frequency: HabitFrequency) {
        let newHabit = Habit(name: name, goal: goal, deadline: deadline, notes: notes, priority: priority, frequency: frequency)
        habits.append(newHabit)
        saveHabits()
    }

    // Function to delete a habit
    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        saveHabits()
    }

    func toggleHabitCompletion(habit: Binding<Habit>) {
        let calendar = Calendar.current
        let now = Date()

        if let lastUpdated = habit.lastUpdated.wrappedValue {
            let isSameDay = calendar.isDate(lastUpdated, inSameDayAs: now)

            if isSameDay {
                habit.isCompleted.wrappedValue.toggle()
            } else {
                habit.isCompleted.wrappedValue = true
                habit.streak.wrappedValue += 1
                habit.totalCompletions.wrappedValue += 1 // Increase total completions
                habit.lastUpdated.wrappedValue = now
            }
        } else {
            habit.isCompleted.wrappedValue = true
            habit.streak.wrappedValue += 1
            habit.totalCompletions.wrappedValue += 1 // Increase total completions
            habit.lastUpdated.wrappedValue = now
        }

        saveHabits()
    }


    // Reset habits for a new day
    func resetHabitsIfNewDay() {
        let calendar = Calendar.current
        let now = Date()

        for index in habits.indices {
            if let lastUpdated = habits[index].lastUpdated {
                if !calendar.isDate(lastUpdated, inSameDayAs: now) {
                    habits[index].isCompleted = false
                }
            } else {
                habits[index].isCompleted = false
            }
        }

        saveHabits()
    }
}

