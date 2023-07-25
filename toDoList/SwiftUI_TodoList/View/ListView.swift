import SwiftUI

struct ListFullView: View {
    @State private var showNotesScreen = false
    @State private var tasks: [TodoItem] = []
    @State private var showDoneTasks = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Мои дела")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(Color("text"))
                .padding(.top, 52)
                .padding(.leading, 32)
            
            HStack {
                Text("Выполнено — \(tasks.filter { $0.isCompleted }.count)")
                    .opacity(0.4)
                Spacer()
                Button(action: {
                    showDoneTasks.toggle()
                }) {
                    Text(showDoneTasks ? "Скрыть" : "Показать")
                        .bold()
                }
            }
            .padding(.horizontal)
            .padding(.top, 2)
            .padding(.leading)
            .padding(.trailing)
            
            ZStack {
                List {
                    ForEach(tasks.indices.filter { showDoneTasks || !tasks[$0].isCompleted }, id: \.self) { index in
                        TaskRow(task: $tasks[index])
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    delete(index: index)
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    tasks[index].isCompleted.toggle()
                                }) {
                                    Image(systemName: tasks[index].isCompleted ? "arrow.uturn.backward" : "checkmark")
                                        .resizable()
                                        .frame(width: 24.0, height: 24.0)
                                        .foregroundColor(tasks[index].isCompleted ? .blue : .green)
                                }
                                .tint(.green)
                            }
                    }
                    Button(action: {
                        self.showNotesScreen.toggle()
                    }) {
                        Text("Новое")
                            .foregroundColor(.gray)
                    }
                }   .background(Color("background"))
                    .scrollContentBackground(.hidden)
            }
            
            Button(action: {
                self.showNotesScreen.toggle()
            }) {
                Image("Add")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            .padding(12)
            .cornerRadius(50)
            .padding(.bottom, 12)
            .padding(.leading, 170)
            .shadow(radius: 10)
            
            .sheet(isPresented: $showNotesScreen) {
                NotesView(onAddItem: { newItem in
                    self.tasks.append(TodoItem(text: newItem))
                })
            }
        }
        .background(Color("background"))
        .environment(\.defaultMinListRowHeight, 56)
    }
    
    func delete(index: Int) {
        tasks.remove(at: index)
    }
}

struct TaskRow: View {
    @Binding var task: TodoItem
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        HStack {
            Button(action: {
                task.isCompleted.toggle()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24.0, height: 24.0)
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            VStack(alignment: .leading) {
                Text(task.text)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .gray : .black)
                if let deadline = task.deadline {
                    Text("Deadline: \(deadline, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }
}

struct ListFullView_Previews: PreviewProvider {
    static var previews: some View {
        ListFullView()
    }
}
