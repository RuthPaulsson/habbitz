import SwiftUI

struct HabitsListView: View {
    let habits: [Habit]
    let onAddHabit: () -> Void
    
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
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
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
                    
                    VStack(spacing: 8) {
                        ForEach(habits) { habit in
                            HabitRowView(habit: habit)
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer(minLength: 90)
                }
            }
            
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
    }
    
    private func isDoneToday(_ habit: Habit) -> Bool {
        habit.completedDates.contains(where: {
            Calendar.current.isDateInToday($0)
        })
    }
}
