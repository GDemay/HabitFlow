import SwiftUI

struct ContentView: View {
    @StateObject var habitStore = HabitStore() // Manage habits
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(habitStore.habits.indices, id: \.self) { index in
                        NavigationLink(destination: HabitDetailView(habit: $habitStore.habits[index], habitStore: habitStore)) {
                            HabitCardView(habit: habitStore.habits[index]) // Use a card view for better UI
                        }
                    }
                    .onDelete(perform: habitStore.deleteHabit)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Habits")
                .navigationBarItems(trailing: Button(action: {
                    habitStore.showingAddHabitForm = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                })
            }
            .sheet(isPresented: $habitStore.showingAddHabitForm) {
                AddHabitView(habitStore: habitStore)
            }
        }
        .onAppear {
            habitStore.loadHabits()
        }
    }
}



#Preview { ContentView() }
