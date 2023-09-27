import SwiftUI
import SwiftDate
import LocalAuthentication

struct TodoView: View {
    @EnvironmentObject var userSetting: UserSetting
    @EnvironmentObject var todoModel: TodoModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.locale) var locate
//    @Environment(\.isFocused) var isFocused
    @Binding var todayMore : Bool
    @Binding var pinnedMore : Bool
    @State private var timeNow : TimeNow = TimeNow.morning
    @State private var todayTitle = "Today"
//    @Environment(\.editMode) var showAdd
    @Binding var showAdd : Bool
    @State var picking = Todo.Frequency.daily
//    @State var todos = Todo.random(count: 5)
//    @State var editTodo = false // true when you edit a todo, false when you create a new todo
    @State var showExportView = false
    @State var showImportView = false
    @State var circleAngle = 0.0
    @State var showSyncView = false
        
    enum TimeNow: String {
        case morning = "☀️"  // [5  , 12)
        case afternoon = "😎"// [12 , 17)
        case night = "🌠"    // [17 , 21)
        case sleeptime = "💤"// [21 , 5)
    }
    
    func updateTimeNow() {
        todoModel.initDicts()
        let day = DateInRegion(Date(),region: .current)
        if day.compare(.isMorning) {
            timeNow = .morning
        } else if day.compare(.isAfternoon){
            timeNow = .afternoon
        } else if day.compare(.isEvening){
            timeNow = .night
        } else if day.compare(.isNight) {
            timeNow = .sleeptime
        } else {
            timeNow = .night
        }
        todayTitle = timeNow.rawValue + "  Today"
    }
    
    private var timeNowString: String{
        switch timeNow {
            case .morning: return "☀️"
            case .afternoon: return "😎"
            case .night: return "✨"
            case .sleeptime: return "💤"
        }
    }
    
    var pinnedTodo:[Todo] {
        todoModel.todos.filter { todo in
            todo.pinned
        }
    }
    
    var todayTodo: [Todo] {
        todoModel.todos.filter {todo in
            switch todo.frequency{
            case .daily : return true
            case .weekdays : return true
            default: return false
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "使用FaceID或TouchID来解锁软件的隐私模式"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        userSetting.showReal = true
                    } else {
                        print(error?.localizedDescription)
                        userSetting.showReal = false
                        // deviceOwnerAuthenticationWithBiometrics时
                        // canceled 在中途点击退出，或是失败后点击退出
                        // failure 多次重试后 使用密码代替
                        // deviceOwnerAuthentication 时支持使用密码作为失败后的验证
                    }
                }
            }
        } else {
            print("device dont use biometrics")
            //多次失败以后 达到最大次数 会走这里
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
//                    List{
                    NavigationLink("all records", destination: AllRecordsViewList())
                    NavigationLink("manage screen time", destination: ScreenTimeManageView())
                    Button{
                        todoModel.saveAll()
                        userSetting.save(me: userSetting)
                    } label: {
                        Text("save all")
                    }
                    MyDisclosureGroup(){
                        //这是一个常驻测试用的嘉宾 可以通过删除这个嘉宾来使程序崩溃
                        //后来可以正常手动添加todo并且编辑和保存了 这个嘉宾就不需要了
//                        Divider()
//                            .padding([.leading,.trailing])
//                        TodoRow(todo: Todo.test, onlyForShow: false)
//                            .padding(.horizontal, 20)
//
                        ForEach(pinnedTodo){ todo in
                            Divider()
                                .padding([.leading,.trailing])
                            TodoRow(todo: todo, onlyForShow: false)
                                .padding(.horizontal, 20)
                                .background(.linearGradient(colors: [ ], startPoint: .top, endPoint: .bottom))
                                .cornerRadius(10)
                        }
//                        ForEach(0..<15){ _ in
//                            Text("test")
//                        }
//                        TodoRow(todo: Todo.test)
                    } label: {
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 27)
                            Text("Pinned")
                                .font(.title2)
                                .bold()
                        }
                    }
//                    MyDisclosureGroup(title: "Pinned", systemImage: "pin.fill", color: .yellow, showMore: $pinnedMore){
//                        Text("test")
//                    }
//                    if pinnedMore {
//                        ForEach(pinnedTodo, id:\.name.real){ todo in
//                            TodoRow(todo: todo)
//                        }
//                    }
                    
                    MyDisclosureGroup(){
                        ForEach(todayTodo){ todo in
                            Divider()
                                .padding([.leading,.trailing])
                            TodoRow(todo: todo, onlyForShow: false)
                                .padding(.horizontal, 20)
                                .background(.linearGradient(colors: [ ], startPoint: .top, endPoint: .bottom))
                                .cornerRadius(10)
                        }
//                        Text("test")
                    } label: {
                        Text(todayTitle)
                            .font(.title2)
                            .bold()
                    }
//                    if todayMore {
////                        ForEach(0..<10) { i in
//                        ForEach(todos) {todo in
//                            //Divider()
//                            //.padding(.leading)
//                            TodoRow(todo: todo)
//                                .padding(.horizontal, 10)
//                            //.padding(.vertical,0)
//                                .background(.linearGradient(colors: [ ], startPoint: .top, endPoint: .bottom))
//                                .cornerRadius(10)
//                                
//                            //.buttonStyle(PlainButtonStyle())
//                        }
//                    } else {
//                        Divider()
//                            .padding([.leading,.trailing])
//                    }
                    
                    Spacer()
//                }
                }
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("ToDo")
                .navigationViewStyle(.stack)
            }
            
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button {
                            circleAngle += 180.0
                            showSyncView = true
                        } label: {
                            Label("云同步", systemImage: "externaldrive.badge.icloud")
                                .rotationEffect(.degrees(circleAngle))
                        }
                        Button {
                            showExportView = true
                        } label: {
                            Label("导出", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            showImportView = true
                        } label: {
                            Label("导入", systemImage: "square.and.arrow.down")
                        }
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button {
                        if (userSetting.showReal){
                            userSetting.showReal = false
                        } else {
//                            userSetting.showReal.toggle()
                            authenticate() //使用生物认证来修改隐私模式
                        }
                    } label: {
                        Image(systemName: userSetting.showReal ? "eyebrow" : "eyes")
                    }
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
//                    EditButton()
                    Button {
                        showAdd.toggle()
//                        editTodo = false
//                        print(todoModel.todos)
                    } label: {
                        Image(systemName: "note.text.badge.plus")
                    }
                })
            })
        }
        .onAppear(perform: updateTimeNow)
//        .blur(radius: showAdd ? 3 : 0)
        .animation(.easeOut(duration: 0.5), value: showAdd)
        //TODO: 关闭sheet之后toolbaritem可能会和系统时间状态栏重合 整体布局上移
        .sheet(isPresented: $showAdd, onDismiss: {
            
        }, content: {
            TodoAdd(todo: Todo.template().copy(), editTodo: false)
        })
        .sheet(isPresented: $showExportView, content: {
            ShareView(toShareTodo: todoModel.export(for: .Todos), toShareRecord: todoModel.export(for: .Records))
        })
        .sheet(isPresented: $showImportView, content: {
            ImportView()
        })
        .sheet(isPresented: $showSyncView, content: {
            SyncView()
        })
        
        
        .onAppear(perform: {
//            todos = todoModel.todos
            pinnedMore = userSetting.showReal
        })
    }
}

//struct MyPreviewProvider_Previews: PreviewProvider {
////    static let todoModel = TodoModel()
//    static var previews: some View {
//        TodoView()
//            .environmentObject(UserSetting(show: true))
//            .environmentObject(TodoModel())
//            .environment(\.colorScheme, .dark)
//            .environment(\.locale, Locale(identifier: "zh"))
//    }
//}
