import SwiftUI

struct GetAllRecords: View {
    @EnvironmentObject var todoModel: TodoModel
    @EnvironmentObject var userSetting: UserSetting
    @State var pop = false
    let todoId: String
    let getSub: Bool
    let todoSubId: String?
    let withDisclosureGroup: Bool
//    lazy var records = recordWithSum()
//    lazy var record = records.record
    @State var records : ([Record],Int,Int) = ([],0,0)
    
    func recordWithSum() -> (record:[Record],sumValue:Int,sumTime:Int) {
        var tempRecord : [Record] = []
        var tempValue = 0
        var tempTime = 0
        for re in todoModel.records {
            if getSub {
                if re.belongsTodoSub == todoSubId {
                    tempRecord.append(re)
                    tempValue += re.value
                    tempTime += re.endTime-re.startTime
                }
            } else {
                if re.belongsTodo == todoId {
                    tempRecord.append(re)
                    tempValue += re.value
                    tempTime += re.endTime-re.startTime
                }
            }
        }
        return (tempRecord,tempValue,tempTime)
    }
    
//    var record : [Record] {
////        return todoModel.records
//        if getSub {
//            return todoModel.records.filter({$0.belongsTodoSub == todoSubId})
//        } else {
//            return todoModel.records.filter({$0.belongsTodo == todoId})
//        }
//    }
    
    var body: some View {
        if withDisclosureGroup {
            DisclosureGroup{
                ForEach(records.0.sorted(by: {(r, rr) -> Bool in
                    return r.startTime.isAfterDate(rr.startTime, granularity: .day)
                })) {re in 
                    RecordView(re: re)
                }
                .onDelete(perform: delete)
            } label: {
                if records.0.count == 0{
                    Text("无打卡记录")
                        .foregroundColor(.gray.opacity(0.9))
                } else {
                    HStack{
                        if (records.1 >= 50){
                            Text("\(records.1)")
                        } else {
                            Image(systemName: "\(records.1).circle")
                        }
//                        Spacer()
                        Text("\(Int.toHour(records.2))")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(records.0.count)")
                            .foregroundColor(.gray)
                    }
//                    Text("\(records.0.count) 条, 总和：\(records.1)，总时： \(Int.toHour(records.2))")
                }
            }
            .disabled(records.0.count==0)
            .onAppear(perform: {
                records = recordWithSum()
            })
        } else {
            ForEach(records.0) {re in 
                RecordView(re: re)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(offsets: IndexSet){
        let c = offsets.count
        guard c == 1 else {return}
//        print("this offsets has \(c) element(s)")
        withAnimation(.default){
            let selected = records.0[offsets.first!]
            deleteRecordFromLocal(record: selected)
            Task{await deleteRecordFromCloud(what: selected.id)}
        }
        todoModel.saveAll()
    }
    
    func deleteRecordFromLocal(record selected: Record) {
        todoModel.updateTodoByRecord(id: selected.belongsTodo, idSub: selected.belongsTodoSub, spentTime: selected.startTime-selected.endTime, times: -1, record: selected)
        todoModel.records.removeAll(where: {$0.id == selected.id})
        userSetting.toDeleteRecord.append(selected.id)
    }
    
    func deleteRecordFromCloud(what id: String) async {
        let idBody = IdBody(id:id)
        let encoder = JSONEncoder()
        let body = (try? encoder.encode(idBody))!
        let action = Fetcher.Actions(url: "record/todelete/add", method: .POST, body: body)
        let fetcher = Fetcher()
        fetcher.serverUrl = userSetting.serverUrl
//        print(action.url)
        try? await fetcher.httpRequest(actions: action, doNext: {data in 
            let decoder = JSONDecoder()
            let returned = (try? decoder.decode(ReturnedJson.self, from: data))!
            if returned.success == 1 {
                print(returned.description)
                return
            } else {
                print(returned.description)
                return
            }
        })
    }
}

struct RecordView: View {
    @State var pop = false
    let re: Record
    
    var body: some View {
        Button {
            pop = true
        } label: {
            HStack {
                if (re.value >= 50){
                    Text("\(re.value)")
                } else {
                    Image(systemName: "\(re.value).circle")
                }
//                Image(systemName: "\(re.value >= 50 ? 50 : re.value).circle")
//                Text("\(re.value)")
                Text("\(Int.toHour(re.endTime-re.startTime))")
                    .foregroundColor(.gray)
                Spacer()
//                (Text(DateFormatter.dateAndTime().string(from: re.startTime))+Text(" - ")+Text(DateFormatter.dateAndTime().string(from: re.endTime)))
//                (Text(re.startTime.formatted(date: .numeric, time: .shortened))+Text(", \(Int.toHour(re.endTime-re.startTime))"))
                Text(re.startTime.formatted(date: .numeric, time: .shortened))
                    .foregroundColor(.gray)
//                    .font(.caption2)
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray.opacity(0.5))
                
            }
        }
        .buttonStyle(.plain)
        //            .popover(item: $pop, attachmentAnchor: PopoverAttachmentAnchor.rect(Anchor.Source(.bottom)), arrowEdge: .bottom){
        .popover(isPresented: $pop) {
            RecordDetailView(re: re)
                .frame(minWidth:300, minHeight: 350)//为了大屏适配 否则就是一小撮弹出窗口
        }
    }
}

struct RecordDetailView: View {
    let re: Record
    @State var value = 0
    @State var startTime = Date()
    @State var endTime = Date()
    @State var source = ""
    @State var note = ""
    @State var sureDelete = false
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var persentationMode
    @EnvironmentObject var todoModel: TodoModel
    @EnvironmentObject var userSetting: UserSetting
    var body: some View {
        VStack {
            HStack {
                Button(role:.cancel){
                    persentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                if editMode?.wrappedValue == .inactive {
                    Text("查看记录")
                } else if editMode?.wrappedValue == .active {
                    Text("编辑记录")
                } else if editMode?.wrappedValue == .transient {
                    Text("临时编辑")
                }
                
                Spacer()
//                EditButton()
                Button {
                    if editMode?.wrappedValue == .inactive {
                        editMode?.wrappedValue = .active
                    } else if editMode?.wrappedValue == .active {
                        let selected = todoModel.records.first(where: {$0.id == re.id})!
                        deleteRecordFromLocal(record: selected)
                        Task{await deleteRecordFromCloud(what: selected.id)}
                        let newRecord = Record(belongsTodo: re.belongsTodo, belongsTodoSub: re.belongsTodoSub, startTime: startTime, endTime: endTime, value: value, source: source, note: note)
                        todoModel.records.append(newRecord)
                        todoModel.updateTodoByRecord(id: re.belongsTodo, idSub: re.belongsTodoSub, spentTime: endTime-startTime, times: -1, record: newRecord)
                        todoModel.save(dataFileName: .Records)
                        editMode?.wrappedValue = .inactive
                    }
                } label: {
                    if editMode?.wrappedValue == .inactive {
                        Text("Edit")
                    } else if editMode?.wrappedValue == .active {
                        Text("Done")
                    }
                }
                .frame(width:45)
                .disabled(endTime-startTime<=0)
            }
            .padding([.horizontal, .top], 15)
            List{
                Section("详细信息") {
                    //          Text("\(re.belongsTodo)")
                    //          Text("\(re.belongsTodoSub)")
//                    TwoLines(text1: "值", text2: re.value)
                    TwoLinesInt(text1: "值", toEditValue: $value)
                    
//                    TwoLines(text1: "开始时间", text2: DateFormatter.localizedString(from: re.startTime, dateStyle: .medium, timeStyle: .medium))
                    TwoLinesDate(text1: "开始时间", toEditValue: $startTime)
                    
//                    TwoLines(text1: "结束时间", text2: DateFormatter.localizedString(from: re.endTime, dateStyle: .medium, timeStyle: .medium))
                    TwoLinesDate(text1: "结束时间", toEditValue: $endTime)
                    
                    TwoLines(text1: "持续时间", text2: "\(endTime-startTime)秒\((endTime-startTime > 60) ?"（\(Int.toHour(endTime-startTime))）":"")")
                    
//                    TwoLines(text1: "打卡设备", text2: re.source)
                    TwoLinesString(text1: "打卡设备", toEditValue: $source)
                    
                    TwoLines(text1: "创建时间", text2: DateFormatter.localizedString(from: re.recordTime, dateStyle: .medium, timeStyle: .medium))
                    
//                    TwoLines(text1: "备注", text2: re.note)
                    TwoLinesString(text1: "备注", toEditValue: $note)
                    
                }
                Section{
                    Button{
                        sureDelete = true
                    } label: {
                        Text("删除这条记录")
                    }
//                    .buttonStyle(.borderless)
                    .foregroundColor(.red)
                }
            }
            .alert(isPresented: $sureDelete) {
                Alert(title: Text("确定删除?"),
                      primaryButton: .destructive(Text("删吧"),action: {
                            let selected = todoModel.records.first(where: {$0.id == re.id})!
                            deleteRecordFromLocal(record: selected)
                            Task{await deleteRecordFromCloud(what: selected.id)}
                          }),
                      secondaryButton: .cancel(Text("算了")))
            }
        }
        .onAppear(perform:{
            value = re.value
            startTime = re.startTime
            endTime = re.endTime
            source = re.source
            note = re.note
        })
    }
    
    
    func deleteRecordFromLocal(record selected: Record) {
        todoModel.updateTodoByRecord(id: selected.belongsTodo, idSub: selected.belongsTodoSub, spentTime: selected.startTime-selected.endTime, times: -1, record: selected)
        todoModel.records.removeAll(where: {$0.id == selected.id})
        userSetting.toDeleteRecord.append(selected.id)
    }
    
    func deleteRecordFromCloud(what id: String) async {
        let idBody = IdBody(id:id)
        let encoder = JSONEncoder()
        let body = (try? encoder.encode(idBody))!
        let action = Fetcher.Actions(url: "record/todelete/add", method: .POST, body: body)
        let fetcher = Fetcher()
        fetcher.serverUrl = userSetting.serverUrl
        //        print(action.url)
        try? await fetcher.httpRequest(actions: action, doNext: {data in 
            let decoder = JSONDecoder()
            let returned = (try? decoder.decode(ReturnedJson.self, from: data))!
            if returned.success == 1 {
                print(returned.description)
                return
            } else {
                print(returned.description)
                return
            }
        })
    }
}


//struct TwoLinesT<T: Any>: View {
//    var text1: String
//    var toEditValue: T
//    @State var intValue: Int = 0
//    @State var stringValue: String = ""
//    @Environment(\.editMode) var editMode
//    
//    var body: some View {
//        VStack(alignment:.leading){
//            Text(text1)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            if editMode?.wrappedValue == .active {
//                switch T{
//                case T as Int:
//                    Stepper(value: $intValue, in: 0...100) {
//                        Text("\(intValue)")
//                    }
//                case T as String:
//                    TextField("", text: $stringValue)
//                }
//            } else {
//                switch T {
//                case T is Int:
//                    Text("\(intValue)")
//                }
//            }
//        }
//        .onAppear(perform: {
//            switch T{
//                case is Int: intValue = toEditValue as! Int
//                case is String: stringValue = toEditValue as! String
//            }
//            
//        })
//    }
//}
// 搞不定泛型 放弃了

struct TwoLinesDate: View {
    var text1: String
    @Binding var toEditValue: Date
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack(alignment:.leading){
            if editMode?.wrappedValue == .active {
                DatePicker(text1, selection: $toEditValue)
            } else {
                Text(text1)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(DateFormatter.localizedString(from: toEditValue, dateStyle: .medium, timeStyle: .medium))")
            }
        }
    }
}

struct TwoLinesInt: View {
    var text1: String
    @Binding var toEditValue: Int
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack(alignment:.leading){
            if editMode?.wrappedValue == .active {
                Stepper(value: $toEditValue, in: 0...100) {
                    Text("值：\(toEditValue)")
                }
            } else {
                Text(text1)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(toEditValue)")
            }
        }
    }
}

struct TwoLinesString: View {
    var text1: String
    @Binding var toEditValue: String
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack(alignment:.leading){
            Text(text1)
                .font(.subheadline)
                .foregroundColor(.gray)
            if editMode?.wrappedValue == .active {
                TextField("", text: $toEditValue)
            } else {
                Text("\(toEditValue)")
            }
        }
    }
}

struct TwoLines: View {
    var text1: String
    var text2: String
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack(alignment:.leading){
            Text(text1)
                .font(.subheadline)
                .foregroundColor(.gray)
            if editMode?.wrappedValue == .active {
                Text(text2)
                    .foregroundColor(.gray)
            } else {
                Text(text2)
            }
            
        }
    }
}

enum EditType {
    case string, int, date
}


//let dateAndTime = DateFormatter()
//dateAndTime.dateFormat = "yyyy-MM-DD HH:mm"
extension DateFormatter {
    static func dateAndTime() -> DateFormatter {
        let dateAndTime = DateFormatter()
        dateAndTime.dateFormat = DateFormatter.dateFormat(fromTemplate: "yy-MM-dd HH:mm", options: 0, locale: Locale.current)
        return dateAndTime
    }
}

extension Date {
    static var dateAndTime : DateFormatter {
        let dateAndTime = DateFormatter()
        dateAndTime.dateFormat = DateFormatter.dateFormat(fromTemplate: "yy-MM-dd HH:mm", options: 0, locale: Locale.current)
        return dateAndTime 
    }
}

//func getRecordsWithId(todoId: String) -> [Record] {
//    
//}
//
//func getRecordsWithId(todoSubId: String) -> [Record] {
//    
//}

//struct GetAllRecords_Previews: PreviewProvider {
//    static var previews: some View {
//        GetAllRecords(todoId: "theOneTodo", getSub: true, todoSubId: "theOneTodoSub")
//            .environmentObject(TodoModel())
//    }
//}
