import SwiftUI

struct SupplementaryView: View {
    @Binding var startTime : Date // = Date(timeIntervalSinceNow: -3600)
    @Binding var endTime : Date// = Date()
    @Binding var value : Int// = 1
//    var todoSub = TodoSub.test
    var todoSub : TodoSub
//    @StateObject var record: Record
    @Binding var source : String
    @Binding var note : String
    
    var body: some View {
        List {
            Section {
//                Button("一小时前 -> 现在"){
//                    startTime = Date(timeIntervalSinceNow: -3600)
//                    endTime = Date()
//                }
//                Button("现在 -> 一小时后"){
//                    startTime = Date()
//                    endTime = Date(timeIntervalSinceNow: 3600)
//                }
                Button("始于时间设为现在"){
                    startTime = Date()
                    //endTime = Date()
                }
                Button("终于时间设为现在"){
                    //startTime = Date()
                    endTime = Date()
                }
//                Button("现在 -> 两小时后"){
//                    startTime = Date()
//                    endTime = Date(timeIntervalSinceNow: 7200)
//                }
            } header: {
                Text("快速设置")
            }
            
            Section {
                DatePicker(selection: $startTime, label: {Text("始于")})
                DatePicker(selection: $endTime, label: {Text("终于")})
                HStack {
                    if endTime.timeIntervalSince(startTime) < -1.0 {
                        Text("时光倒流了属于是")
                            .foregroundColor(.red.opacity(0.5))
                    }
                    Spacer()
                    Text("间隔：\(Int.toHour(Int(endTime.timeIntervalSince(startTime))))")
                        .foregroundColor(.gray.opacity(0.5))
                }
                Stepper(value: $value, in: 0...100) {
                    Text("增加 \(value)")
                }
            } header: {
                Text("记录")
            }
            
            Section {
                Text("\(todoSub.statistics.getDescription(today: true, false, false))\n  ->   \(todoSub.statistics.tempValueToday + ((startTime.compare(.isToday) || endTime.compare(.isToday)) ? value : 0)) \(todoSub.statistics.unitDescription.show)，\(Int.toHour(endTime-startTime+todoSub.statistics.tempTimeToday))")
                Text("\(todoSub.statistics.getDescription(today: false))\n  ->   \(todoSub.statistics.tempValueTotal + value)\(todoSub.statistics.endless ? "" : "/"+String(todoSub.statistics.endValue)) \(todoSub.statistics.unitDescription.show)，\(Int.toHour(endTime-startTime+todoSub.statistics.tempTimeTotal))")
            } header: {
                Text("\(todoSub.statistics.description.show)")
            }
            
            Section {
                TextField("打卡来源", text: $source)
                TextEditor(text: $note)
            } header: {
                Text("备注")
            }
        }
    }
}

//struct SupplementaryView_Previews: PreviewProvider {
//    $static var previews: some View {
////        SupplementaryView(todoSub: TodoSub.random())
////        AddRecordView(todo: Todo.test)
//    }
//}
