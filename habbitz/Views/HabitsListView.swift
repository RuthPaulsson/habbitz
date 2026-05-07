import SwiftUI
import SwiftData

struct HabitsListView: View {
    let habits: [Habit]
    let onAddHabit: () -> Void
 
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HabitViewModel()
 
    @State private var habitToDelete: Habit?
    @State private var showDeleteConfirmation = false
 
    private var completedToday: Int {
        habits.filter { isDoneToday($0) }.count
    }
 
    private var todayLabel: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sv_SE")
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: Date()).uppercased()
    }
 
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                VStack(alignment: .leading, spacing: 4) {
                    Text(todayLabel)
                        .font(.caption)
                        .foregroundStyle(Color.active)
                    Text("Mina vanor")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.darkText)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
 
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Dagens framsteg")
                            .font(.subheadline)
                            .foregroundStyle(Color.darkText)
                        Spacer()
                        Text("\(completedToday) / \(habits.count)")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color.darkText)
                    }
                    ProgressView(
                        value: Double(completedToday),
                        total: Double(max(habits.count, 1))
                    )
                    .tint(Color.accent)
                }
                .padding(14)
                .background(Color("secondary"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
 
                ForEach(habits) { habit in
                    HabitRowView(
                        habit: habit,
                        streak: viewModel.currentStreak(for: habit),
                        onToggle: {
                            viewModel.toggleDone(habit: habit, context: modelContext)
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            habitToDelete = habit
                            showDeleteConfirmation = true
                        } label: {
                            Label("Radera", systemImage: "trash")
                        }
                    }
                }
 
                Color.clear
                    .frame(height: 80)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
 
            Button(action: onAddHabit) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color("background"))
                    .frame(width: 56, height: 56)
                    .background(Color.accent)
                    .clipShape(Circle())
            }
            .padding(.trailing, 22)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Fel", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Något gick fel.")
        }
        .alert(
            "Radera \"\(habitToDelete?.name ?? "")\"?",
            isPresented: $showDeleteConfirmation,
            presenting: habitToDelete
        ) { habit in
            Button("Avbryt", role: .cancel) {
                habitToDelete = nil
            }
            Button("Radera", role: .destructive) {
                viewModel.deleteHabit(habit, context: modelContext)
                habitToDelete = nil
            }
        } message: { habit in
            Text(deleteMessage(for: habit))
        }
    }
 
    private func isDoneToday(_ habit: Habit) -> Bool {
        habit.completedDates.contains(where: {
            Calendar.current.isDateInToday($0)
        })
    }
 
    private func deleteMessage(for habit: Habit) -> String {
        let streak = viewModel.currentStreak(for: habit)
        if streak > 0 {
            let dagar = streak == 1 ? "dag" : "dagar"
            return "Din streak på \(streak) \(dagar) försvinner och kan inte återställas."
        } else {
            return "Detta går inte att ångra."
        }
    }
}
 
