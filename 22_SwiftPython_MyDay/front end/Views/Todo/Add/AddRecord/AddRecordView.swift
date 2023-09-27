import SwiftUI

struct AddRecordView: View {
    @EnvironmentObject var todoModel: TodoModel
    @EnvironmentObject var userSetting: UserSetting
    var todo: Todo
    @State var selection: Selection = .supplementary
    @State var subSelection = 0
    @Binding var showSelf: Bool
    
//    @State var record = Record.empty
    var id : String {todo.id}
    var idSub : String {sortedTodoSubs[subSelection].id}
    @State var startTime = Date().dateRoundedAt(at: .toFloorMins(1))
    @State var endTime = Date().dateRoundedAt(at: .toCeilMins(1))
    @State var value = 1
    @State var source = ""
    @State var note = ""
    
    var sortedTodoSubs : [TodoSub] {
        if userSetting.sortTodoSubsByRecent {
            return todo.todoSubSorted
        } else {
            return todo.todoSub
        }
    }
    
    
    enum Selection {
        case tomato
        case onlyTimes
        case supplementary //本来是叫做"补录打卡"的 后来改名了 变量名就不改了
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("不打了", role: .cancel){
                    showSelf = false
                }
                .frame(width: 70)
                Spacer()
                Image(systemName: todo.icon.show)
                    .foregroundColor(todo.iconColor.toColor())
                Text("\(todo.name.show) ")
//                    .font(.title3)
                Picker(selection: $subSelection, label: Text("子任务选择")) {
                    ForEach(0 ..< sortedTodoSubs.count) {index in
                        Text(sortedTodoSubs[index].name.show).tag(index)
//                            .font(.title3)
                    }
                }
                .pickerStyle(.automatic)
                .padding(0)
                
                Spacer()
                Text("")
                    .frame(width: 40)
            }
            .padding([.top,.horizontal])
//            List {
//                Group {

                    
                    Picker(selection: $selection, label: Text("选择打卡类型")) {
                        Text("番茄").tag(Selection.tomato)
                        Text("仅记次").tag(Selection.onlyTimes)
                        Text("计时记量").tag(Selection.supplementary)
                    }
                    .pickerStyle(.segmented)
                    
                    switch selection {
                    case .tomato: TomatoView()
                    case .onlyTimes: OnlyTimesView(todoSub: sortedTodoSubs[subSelection])
                    case .supplementary: SupplementaryView(startTime: $startTime, endTime: $endTime, value: $value, todoSub: sortedTodoSubs[subSelection], source: $userSetting.deviceName, note: $note)
                    }
//                }
            
            Spacer()
            HStack {
                Button{
                    switch selection {
                        case .tomato: print("Tomato!")
                        case .onlyTimes: print("onlyTimes!")
                        case .supplementary:
//                        print("\(id)\n\(idSub)\n\(startTime)\n\(endTime)\n\(value)")
                        let record = Record(belongsTodo: id, belongsTodoSub: idSub, startTime: startTime, endTime: endTime, value: value, source: userSetting.deviceName, note: note)
                        todoModel.records.append(record)
//                        todoModel.todos
                        todoModel.updateTodoByRecord(id:id, idSub: idSub, spentTime: endTime - startTime , times:1, record: record)
                        todoModel.save(dataFileName: .Records)
                    }
                } label: {
                    Label("添加打卡记录",systemImage: "plus.circle.fill")
//                        .padding(.bottom)
                }
                .buttonStyle(.borderless)
                .padding(.leading, 25)
                .padding(.bottom, 30)
                
                Spacer()
            }
            
        }
        .onAppear(perform: {
//            record.belongs = todo.id
//            id = todo.id
//            idSub = todo.todoSub[subSelection].id
//            source = userSetting.deviceName
        })
        
    }
}

//struct AddRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddRecordView(todo: Todo.test)
//    }
//}
