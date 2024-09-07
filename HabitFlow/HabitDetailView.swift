import SwiftUI

struct HabitDetailView: View {
    @Binding var habit: Habit
    @ObservedObject var habitStore: HabitStore

    // Progress calculation based on the number of days between the start (or last update) and the deadline
    var progress: Float {
        let calendar = Calendar.current
        let now = Date()

        // Ensure the deadline is set and calculate progress
        if let deadline = habit.deadline {
            // If deadline is in the past, return 100% progress
            if deadline < now {
                return 1.0
            }
            
            // Calculate total days between the last update (or now) and the deadline
            let startDate = habit.lastUpdated ?? now
            let totalDays = calendar.dateComponents([.day], from: startDate, to: deadline).day ?? 1
            let elapsedDays = calendar.dateComponents([.day], from: startDate, to: now).day ?? 0

            if totalDays > 0 {
                return Float(elapsedDays) / Float(totalDays) // Progress in percentage
            }
        }

        // Default progress (if no deadline or invalid dates)
        return 0.0
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(habit.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)

                // Completion Button
                Button(action: {
                    toggleHabitCompletion() // Update habit status and progress
                }) {
                    HStack {
                        Spacer()
                        Text(habit.isCompleted ? "Completed Today!" : "Mark as Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(habit.isCompleted ? Color.green : Color.blue)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        Spacer()
                    }
                }

                VStack(spacing: 20) {
                    Text("Progress")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Current Streak: \(habit.streak) days")
                                .font(.subheadline)
                            Text("Total Completions: \(habit.totalCompletions)")
                                .font(.subheadline)
                        }
                        Spacer()
                        
                        // Circular progress bar with updated progress calculation
                        CircularProgressBar(progress: progress)
                            .frame(width: 100, height: 100) // Correct size
                    }
                }
                .padding(.vertical, 20)

                // Calendar View
                CalendarView(completionDates: habit.completionDates)
            }
            .padding(.horizontal, 16)
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            habitStore.showingEditHabitForm = true
        }) {
            Image(systemName: "pencil")
                .font(.title2)
        })
        .sheet(isPresented: $habitStore.showingEditHabitForm) {
            EditHabitView(habit: $habit, habitStore: habitStore)
        }
    }

    // Toggle completion status and update calendar and progress
    func toggleHabitCompletion() {
        let calendar = Calendar.current
        let now = Date()

        if let lastUpdated = habit.lastUpdated {
            let isSameDay = calendar.isDate(lastUpdated, inSameDayAs: now)

            if isSameDay {
                habit.isCompleted.toggle()
                if habit.isCompleted {
                    habit.streak += 1
                    habit.totalCompletions += 1
                    habit.completionDates.append(now)
                } else {
                    habit.streak = max(0, habit.streak - 1)
                    habit.totalCompletions = max(0, habit.totalCompletions - 1)
                    habit.completionDates.removeAll { calendar.isDate($0, inSameDayAs: now) }
                }
            } else {
                habit.isCompleted = true
                habit.streak += 1
                habit.totalCompletions += 1
                habit.lastUpdated = now
                habit.completionDates.append(now)
            }
        } else {
            habit.isCompleted = true
            habit.streak += 1
            habit.totalCompletions += 1
            habit.lastUpdated = now
            habit.completionDates.append(now)
        }

        habitStore.saveHabits()
    }
}
