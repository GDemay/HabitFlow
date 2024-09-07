import SwiftUI

struct EditHabitView: View {
    @Binding var habit: Habit
    @ObservedObject var habitStore: HabitStore
    
    // State to track the new deadline
    @State private var newDeadline: Date = Date()

    var body: some View {
        Form {
            Section(header: Text("Edit Habit")) {
                TextField("Habit Name", text: $habit.name)

                DatePicker("Deadline", selection: $newDeadline, in: Date()..., displayedComponents: .date)
                    .onChange(of: newDeadline) { newValue in
                        // Prevent past deadlines
                        habit.deadline = newValue
                    }

                Picker("Priority", selection: $habit.priority) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Button(action: {
                habitStore.saveHabits()
            }) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
            }
        }
    }
}
