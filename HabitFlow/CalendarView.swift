import SwiftUI

struct CalendarView: View {
    var completionDates: [Date]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Completion Calendar")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
                ForEach(getCurrentMonthDates(), id: \.self) { date in
                    CalendarDateView(date: date, isCompleted: isDateCompleted(date: date))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    // Get the dates for the current month
    private func getCurrentMonthDates() -> [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }

    // Check if the date is completed
    private func isDateCompleted(date: Date) -> Bool {
        let calendar = Calendar.current
        // Compare dates only by day, month, year (ignoring time)
        return completionDates.contains(where: { calendar.isDate($0, inSameDayAs: date) })
    }
}

struct CalendarDateView: View {
    var date: Date
    var isCompleted: Bool
    
    var body: some View {
        let today = Calendar.current.isDateInToday(date)

        VStack {
            Text(date.formatted(.dateTime.day()))
                .fontWeight(.bold)
                .foregroundColor(today ? .blue : (isCompleted ? .white : .gray)) // Highlight today in blue
                .frame(width: 40, height: 40)
                .background(isCompleted ? Color.green : (today ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))) // Show today in light blue
                .cornerRadius(8)
        }
    }
}
