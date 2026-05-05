import SwiftData
import SwiftUI

struct NewHabitView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var viewModel = HabitViewModel()
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Namn") {
                    TextField("T.ex. Dricka vatten", text: $name)
                }
            }
            .navigationTitle("Ny vana")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Spara") {
                        viewModel.addHabit(name: name, context: modelContext)
                        if !viewModel.showError {
                            dismiss()
                        }
                    }
                    .disabled(!isValid)
                }
            }
            .alert("Fel", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Något gick fel.")
            }
        }
    }
}

#Preview {
    NewHabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}

