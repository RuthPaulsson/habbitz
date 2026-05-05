import Foundation
import SwiftData

@Observable
class HabitViewModel {
    
    var errorMessage: String?
    var showError: Bool = false
    
    func addHabit(name: String, context: ModelContext) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            errorMessage = "Vanan måste ha ett namn"
            showError = true
            return
        }
        
        do {
            let newHabit = Habit(name: trimmed)
            context.insert(newHabit)
            try context.save()
        } catch {
            errorMessage = "Kunde inte spara vanan" + error.localizedDescription
            showError = true
        }
    }
}

