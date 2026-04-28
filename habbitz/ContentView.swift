import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var habits: [Habit]

    var body: some View {
        NavigationStack {
            List(habits) { habit in
                Text(habit.name)
            }
            .overlay {
                if habits.isEmpty {
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
            }
            .scrollContentBackground(.hidden)
            .background(Color("background"))
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
