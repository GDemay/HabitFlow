import SwiftUI

struct AddHabitView: View {
    @ObservedObject var habitStore: HabitStore
    
    @State private var habitName: String = ""
    @State private var habitGoal: String = ""
    @State private var habitDeadline: Date = Date()
    @State private var habitPriority: String = "Medium"
    @State private var habitNotes: String = ""
    @State private var habitFrequency: HabitFrequency = .daily // Add frequency state

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Information")) {
                    TextField("Habit Name", text: $habitName)
                    TextField("Goal (e.g., Run 3x a week)", text: $habitGoal)
                    DatePicker("Deadline", selection: $habitDeadline, displayedComponents: .date)
                    Picker("Priority", selection: $habitPriority) {
                        Text("High").tag("High")
                        Text("Medium").tag("Medium")
                        Text("Low").tag("Low")
                    }
                    TextField("Notes", text: $habitNotes)
                }
                
                Section(header: Text("Habit Frequency")) {
                    Picker("Frequency", selection: $habitFrequency) {
                        ForEach(HabitFrequency.allCases) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Use segmented style for better UI
                }
            }
            .navigationBarTitle("Add Habit", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                habitStore.showingAddHabitForm = false
            }, trailing: Button("Save") {
                habitStore.addHabit(
                    name: habitName,
                    goal: habitGoal,
                    deadline: habitDeadline,
                    priority: habitPriority,
                    notes: habitNotes,
                    frequency: habitFrequency // Pass the frequency
                )
                habitStore.showingAddHabitForm = false
            })
        }
    }
}
