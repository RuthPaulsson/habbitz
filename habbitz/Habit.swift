import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var createdAt: Date
    var completedDates: [Date]

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.completedDates = []
    }
}
