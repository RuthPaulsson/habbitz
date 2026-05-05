import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var habits: [Habit]
    @State private var showingNewHabit = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background").ignoresSafeArea()
                
                if habits.isEmpty {
                    Button {
                        showingNewHabit = true
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 48))
                                .foregroundStyle(Color.accent)
                            Text("Du har inga vanor än")
                                .font(.title3)
                                .foregroundStyle(Color.darkText)
                            Text("Tryck + för att börja")
                                .font(.subheadline)
                                .foregroundStyle(Color.active)
                        }
                    }
                    .buttonStyle(.plain)
                    
                } else {
                    HabitsListView(
                        habits: habits,
                        onAddHabit: { showingNewHabit = true }
                    )
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingNewHabit) {
                NewHabitView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
