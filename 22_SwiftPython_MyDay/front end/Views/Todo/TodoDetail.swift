import SwiftUI

struct TodoDetail: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var todoModel: TodoModel
    @StateObject var todo: Todo
    @State private var selection : Selection = .edit
    
    enum Selection: String, CaseIterable {
        case edit 
        case record
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                Text("编辑").tag(Selection.edit)
                Text("记录").tag(Selection.record)
            }
            .pickerStyle(.segmented)
            
            switch selection {
            case .edit: TodoAdd(todo: todo, editTodo: true)
            case .record: AllRecordsView(todo: todo)
            }
            
        }
        .navigationTitle(todo.name.show)
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button{
                    todo.pinned.toggle()
                } label: {
                    Image(systemName: todo.pinned ? "pin" : "pin.slash")
                        .symbolRenderingMode(.multicolor)
                }
                .buttonStyle(.plain)
            })
//            ToolbarItem(placement: .navigationBarTrailing, content: {
//                Button{
//
//                } label: {
//                    Image(systemName: "trash")
//                        .symbolRenderingMode(.multicolor)
//                }
//            })
        })
    }
}

struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetail(todo: Todo.test)
            .environmentObject(UserSetting(show: false))
    }
}
