import SwiftUI

struct AllRecordsView: View {
//    @EnvironmentObject var todoModel: TodoModel
    @State var addingRecord = false
    let todo: Todo
    
    var body: some View {
        List {
//            GetAllRecords(todoId: todo.id, getSub: false, todoSubId: "")
            Button("添加一条记录"){
                addingRecord.toggle()
            }
            ForEach(todo.todoSub) { sub in
                Section{
                    GetAllRecords(todoId: todo.id, getSub: true, todoSubId: sub.id, withDisclosureGroup: true)
                } header: {
                    Text(sub.name.show)
//                    +Text(sub.id)
                }
            }
        }
        .sheet(isPresented: $addingRecord){
            AddRecordView(todo: todo, showSelf: $addingRecord)
        }
    }
}

struct AllRecordsViewListUgly: View {
    @EnvironmentObject var todoModel: TodoModel
    var body: some View {
        List {
            ForEach(todoModel.todos){ todo in
                GetAllRecords(todoId: todo.id, getSub: false, todoSubId: "", withDisclosureGroup: false, records:(todoModel.records,0,0))
            }
        }
    }
}

struct AllRecordsViewList: View {
    @EnvironmentObject var todoModel: TodoModel
    @State var showScreenTime = false
    var sorted : [Record] {
        var filtered : [Record] = []
        if !showScreenTime {
            filtered = todoModel.records.filter({$0.belongsTodo != "screenTime"})
        } else {
            filtered = todoModel.records
        }
        return filtered.sorted(by: {(r, rr) -> Bool in
            return r.recordTime.isAfterDate(rr.recordTime, granularity: .day)
        })
    }
    var body: some View {
        List {
            Toggle("显示ScreenTime", isOn: $showScreenTime)
            ForEach(sorted) { record in 
                let todoNow = todoModel.todosDict[record.belongsTodo] ?? Todo.unknown
               // let todoSubNow = todoModel.todoSubsDict[record.belongsTodoSub] ?? TodoSub.unknown
               // RecordRow(todoName: todoNow.name.show, todoSubName: todoSubNow.name.show, re: record)
                let todoSubNowName = todoModel.todoSubsDict[record.belongsTodoSub]?.name.show ?? record.belongsTodoSub
                RecordRow(todoName: todoNow.name.show, todoSubName: todoSubNowName, re: record)
            }
        }
        .onAppear(perform: {
        })
    }
}

struct RecordRow: View {
    let todoName: String
    let todoSubName: String
    let re: Record
    @State var pop = false
    
    var body: some View {
        Button {
            pop = true
        } label: {
            HStack {                    
                Text("\(todoName).\(todoSubName)")
                Spacer()
                VStack(alignment:.leading){
                    Text(re.startTime.formatted(date: .numeric, time: .shortened))
                    HStack{
                        Text("\(re.value)")
                        Spacer()
                        Text("\(Int.toHour(re.endTime-re.startTime))")
                    }
                    .frame(maxWidth: 125)
                }
                    .foregroundColor(.gray)
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .buttonStyle(.plain)
        .popover(isPresented: $pop) {
            RecordDetailView(re: re)
                .frame(minWidth:300, minHeight: 350)//为了大屏适配 否则就是一小撮弹出窗口
        }
    }
}

struct AllRecordsViewList_Previews: PreviewProvider {
        static var previews: some View {
            AllRecordsViewList()
                .environmentObject(TodoModel())
        }
    }

//struct AllRecordsViewList_Previews: PreviewProvider {
//    static var previews: some View {
//        AllRecordsViewListUgly()
//            .environmentObject(TodoModel())
//    }
//}

//struct AllRecordsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllRecordsView(todo: Todo.test)
//            .environmentObject(TodoModel())
//    }
//}
