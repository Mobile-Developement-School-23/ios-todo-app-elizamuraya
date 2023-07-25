import SwiftUI

struct NotesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var tasks: [TodoItem] = []
    @State private var newItem = ""
    @State private var text = ""
    @State private var importance = "Важность"
    @State private var favoriteColor = 0
    @State private var isDeadlineOn = false
    @State private var date = Date()
    @State private var deadline = Date()
    @State private var color: Color = .clear
    @State private var showCalendar = false
    @FocusState private var textIsFocused: Bool
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()


    
    var onAddItem: (String) -> Void
    struct TextEditorWithPlaceholder: View {
        @Binding var text: String
        
        var body: some View {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    VStack {
                        Text("Что надо сделать?")
                            .padding(.top, 10)
                            .padding(.leading, 6)
                            .foregroundColor(.gray)
                            
                        Spacer()
                    }
                }
                
                VStack {
                    TextEditor(text: $text)
                        .cornerRadius(16)
                        .frame(minHeight: 120, maxHeight: 300)
                        .opacity(text.isEmpty ? 0.85 : 1)
                    Spacer()
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextEditorWithPlaceholder(text: $text)
                    .focused($textIsFocused)
                }
                
                Section {
                    HStack {
                        TextField("Важность", text: $importance)
                        Picker("What is your favorite color?", selection: $favoriteColor) {
                            Image("low-priority").tag(0)
                            Text("нет").tag(1)
                            Image("exclamaition-mark").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .frame(height: 33)
                        .scaledToFit()
                        .scaleEffect(CGSize(width: 1.1, height: 1.1))
                    }
                    HStack {
                        VStack(alignment:.leading) {
                            Text("Сделать до")
                            if showCalendar {
                                Text(dateFormatter.string(from: date))
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        }
                        Toggle(isOn: $showCalendar) {}
                    }
                    
                    if showCalendar {
                        DatePicker("", selection: $date,
                                   in: Date()...,
                                   displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .environment(\.locale, Locale.init(identifier: "ru"))
                    }
                }

                Button(action: {
                                   self.onAddItem(self.newItem)
                                   self.newItem = ""
                               }) {
                                   Text("Удалить")
                                       .frame(maxWidth: .infinity)
                                       .cornerRadius(10)
                                       .foregroundColor(text.isEmpty ? .gray : .red)
                               }
            }
            .listRowInsets(EdgeInsets())
            .scrollContentBackground(.hidden)
            .background(Color("background"))
            .foregroundColor(.primary)

            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Дело")
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    
                    Text("Отменить")
                        .foregroundColor(.blue)
                },
                trailing: Button(action: {
                    self.onAddItem(self.newItem)
                    self.newItem = ""
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Сохранить")
                        .foregroundColor(text.isEmpty ? .gray : .blue)
                       .bold()
                }
            )
        }
    }
}
