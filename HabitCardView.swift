import SwiftUI

struct HabitCardView: View {
    var habit: Habit

    var body: some View {
        ZStack {
            // Neutral background with soft rounded corners
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemGray6)) // Neutral light gray background
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5) // Subtle shadow
            
            VStack(alignment: .leading, spacing: 10) {
                // Title of the habit
                HStack {
                    Text(habit.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary) // Adaptable to dark mode
                    Spacer()
                    // Checkmark if the habit is completed
                    if habit.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
                
                // Streak and deadline information
                Text("Streak: \(habit.streak) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary) // Lighter text for secondary info
                
                if let deadline = habit.deadline {
                    Text("Deadline: \(deadline.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .frame(height: 100) // Uniform height for all cards
        .padding(.horizontal)
    }
}
