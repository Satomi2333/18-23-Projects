import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSetting: UserSetting
    @EnvironmentObject var todoModel: TodoModel
    @Environment(\.scenePhase) private var scenePhase
    @State var todosDict : [String:Todo] = [:]
    
    enum Tab: String {
        case todo
        case togo
        case tosummarize
    }
    @AppStorage("contentView.tab") private var tab = Tab.todo
//    @AppStorage("test") private var test = false
    
    @AppStorage("todoView.todayMore") private var todayMore = true
    @AppStorage("todoView.pinnedMore") private var pinnedMore = true
    @AppStorage("todoView.showAdd") private var showAdd = false
    
    var body: some View {
        ZStack {
            TabView(selection: $tab) {
                TodoView(todayMore: $todayMore, pinnedMore: $pinnedMore, showAdd: $showAdd)
                    .tabItem {
    //                    Label("ToDo",systemImage: "sun.max")
                        Text("ToDo")
                        Image(systemName: "sun.max.fill")
                            .symbolRenderingMode(.multicolor)
                    }
                    .tag(Tab.todo)
                TogoView()
                    .tabItem {
                        Label("ToGo",systemImage: "figure.walk")
                    }
                    .tag(Tab.togo)
                ToSummarizeView()
                    .tabItem {
                        Text("ToMe")
                        Image(systemName: "hammer.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .colorMultiply(.accentColor)
                    }
                    .tag(Tab.tosummarize)
            }
            .onChange(of: scenePhase, perform: { newPhase in
                if newPhase == .inactive {
                    todoModel.saveAll()
                    userSetting.save(me: userSetting)
                }
            })
            .onAppear(perform: {
    //            createDict()
    //            calcTimes()
            })
            
            VStack {
//                Spacer()
                NotificationView()
                Spacer()
            }
        }
        
    }
    
    // 这个函数被放到Model里面去了
//    func createDict() {
//        for todo in todoModel.todos {
//            todosDict[todo.id] = todo
//        }
//    }
    
    //这个也是
//    func calcTimes() {
//        var temp : [String:[Int]] = [:]
////        var spentTime : []
//        for record in todoModel.records {
////            todosDict[record.belongsTodo]?.finishedTimes
//            if temp[record.belongsTodo] != nil {
//                temp[record.belongsTodo]?[0] += 1
////                temp[record.belongsTodo]?[1] += Int( record.endTime.timeIntervalSince(record.startTime))// - record.startTime
//                temp[record.belongsTodo]?[1] += record.endTime - record.startTime //extention Date - 运算符
//                
//            } else {
//                temp[record.belongsTodo] = [1, record.endTime - record.startTime]
//            }
//        }
//        for (todoId,values) in temp {
//            todosDict[todoId]?.finishedTimes = values[0]
//            todosDict[todoId]?.spentTime = values[1]
//        }
//    }
}

struct NotificationView: View {
    @State var offset = CGSize(width: 0.0, height: 50.0)
    @EnvironmentObject var userSetting: UserSetting
    var dragGesture : some Gesture {
        DragGesture()
            .onChanged{ value in
                offset = CGSize(width: value.startLocation.x + value.translation.width-180,
                                height: value.startLocation.y + value.translation.height-20)
            }
    }
    
    var body: some View {
        Text(userSetting.notification)
            .frame(width: 320, height: 40, alignment: .center)
            .background(Color.accentColor.opacity(0.6), in: RoundedRectangle(cornerRadius: 10))
            .offset(offset)
            .gesture(dragGesture)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView().environmentObject(UserSetting(show: false))
    }
}
