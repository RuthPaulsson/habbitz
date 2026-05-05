import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let onToggle: () -> Void
    
    private var isDoneToday: Bool {
        habit.completedDates.contains(where: {
            Calendar.current.isDateInToday($0)
        })
    }
    
    private var currentStreak: Int {
        var streak = 0
        var checkDate = Date()
        let calendar = Calendar.current
        while habit.completedDates.contains(where: {
            calendar.isDate($0, inSameDayAs: checkDate)
        }) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = previous
        }
        return streak
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(String(habit.name.prefix(1).uppercased()))
                .font(.headline)
                .foregroundStyle(Color.darkText)
                .frame(width: 36, height: 36)
                .background(isDoneToday ? Color("background") : Color("secondary"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.darkText)
                
                if currentStreak > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("\(currentStreak) dagar")
                            .font(.caption)
                            .foregroundStyle(Color.darkText)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onToggle) {
            Image(systemName: isDoneToday ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 26))
                .foregroundStyle(isDoneToday ? Color.darkText : Color.active)
        }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(isDoneToday ? Color.active : Color("card"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
