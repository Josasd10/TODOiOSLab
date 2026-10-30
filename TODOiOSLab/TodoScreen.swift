
import SwiftUI

struct TodoScreen: View {

    // @State conserva el estado de la vista.
    // SwiftUI actualiza la interfaz cuando cambia.

    @State private var todos = Todo.examples
    @State private var newTodoText = ""

    // LAB 4: Contar las tareas pendientes.
    private var remainingCount: Int {
        todos.filter { !$0.isDone }.count
    }

    var body: some View {
        NavigationStack {
            List {

                // Encabezado de la aplicación
                Section {
                    LabHeader(
                        remainingCount: remainingCount,
                        totalCount: todos.count,
                        storageLabel: "En memoria · laboratorio principal"
                    )
                }

                // LAB 2: Agregar nuevas tareas
                Section("Nueva tarea") {
                    HStack {
                        TextField(
                            "¿Qué quieres hacer?",
                            text: $newTodoText
                        )
                        .accessibilityIdentifier("newTodoField")
                        .submitLabel(.done)
                        .onSubmit {
                            addTodo()
                        }

                        Button(action: addTodo) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                        .accessibilityLabel("Agregar tarea")
                        .accessibilityIdentifier("addTodoButton")
                        .disabled(
                            newTodoText
                                .trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                                .isEmpty
                        )
                        .buttonStyle(.borderless)
                    }
                }

                // LAB 3: Mostrar y completar tareas
                Section("Mis tareas") {

                    if todos.isEmpty {
                        ContentUnavailableView(
                            "Tu lista está lista",
                            systemImage: "checkmark.circle",
                            description: Text(
                                "Agrega una tarea para comenzar."
                            )
                        )
                    }

                    ForEach(todos) { todo in
                        TodoRow(
                            title: todo.title,
                            isDone: todo.isDone,
                            onToggle: {
                                toggleTodo(id: todo.id)
                            },
                            onDelete: {
                                todos.removeAll {
                                    $0.id == todo.id
                                }
                            }
                        )
                    }
                }
            }
            .navigationTitle("Mis tareas")
        }
    }

    // LAB 2: Agregar una tarea nueva
    private func addTodo() {

        let title = newTodoText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !title.isEmpty else {
            return
        }

        // Agregar la tarea al arreglo
        todos.append(Todo(title: title))

        // Limpiar el campo de texto
        newTodoText = ""
    }

    // LAB 3: Marcar o desmarcar una tarea
    private func toggleTodo(id: UUID) {

        guard let index = todos.firstIndex(
            where: { $0.id == id }
        ) else {
            return
        }

        // Invertir el estado de la tarea
        todos[index].isDone.toggle()
    }
}

// Vista previa de la aplicación
#Preview {
    TodoScreen()
        .tint(LabSettings.accentColor)
}
