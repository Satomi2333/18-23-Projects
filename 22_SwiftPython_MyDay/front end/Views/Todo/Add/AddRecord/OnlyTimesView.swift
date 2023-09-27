import SwiftUI

struct OnlyTimesView: View {
    @State var startTime = Date()
    @State var endTime = Date()
    @State var times = 1
    @State var step = 1
//    var todoSub: TodoSub = TodoSub.test
    var todoSub: TodoSub
    
    var tooManyTimes : String {
        if times == 1 {
            return ""
        } else if times <= 10 {
            return "没有意义"
        } else if times <= 20 {
            return "打那么多干嘛"
        } else if times <= 50 {
            return "别点了系统记不住你打那么多次"
        } else if times <= 100 {
            return "算了随你便吧"
        } else if times <= 200 {
            return "手酸吗勇士 要不试试点点我"
        } else if times <= 300 {
            return "别点了没了"
        } else if times <= 400 {
            return "真的没了别试了"
        } else if times <= 500 {
            return ""
        } else {
            return "又见面了，自己玩儿吧"
        }
    }
    
    var body: some View {
        List {
            Section {
                DatePicker("打卡时间", selection: $startTime)
                Stepper(value: $times, in: 1...1000, step: step) {
                    Text("打卡 \(times) 次")
                }
                
            } header: {
                Text("计次")
            } footer: {
                Text(tooManyTimes)
                    .onTapGesture {
                        step += 1
                    }
            }
            
            Section {
                Text("")
            } header: {
                Text("\(todoSub.statistics.description.show)")
            }
            
            Section {
//                Button("add"){
//                    
//                }
//                ForEach()
                Text("")
            } header: {
                Text("record")
            }
        }
    }
}

struct OnlyTimesView_Previews: PreviewProvider {
    static var previews: some View {
        OnlyTimesView(todoSub: TodoSub.test)
    }
}
