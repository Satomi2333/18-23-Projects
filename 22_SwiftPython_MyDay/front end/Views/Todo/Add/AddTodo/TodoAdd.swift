import SwiftUI

struct TodoAdd: View {
    @EnvironmentObject var userSetting: UserSetting
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var todo : Todo = Todo.template()
    @State var colorTemp : MyColor = .random()
//    @Binding var adding: Bool
    @State var addingSub: Bool = false
//    @State var todoSub = TodoSub.empty
    @StateObject var todoSubEmpty = TodoSub.empty
    @State var frequency = Todo.Frequency.daily
    @State var picking: Bool = false
    @State var addRecord = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoModel: TodoModel
    @State var addFakeString = true
    @State var editNow = 0
    var editTodo: Bool
    @State var deleteAlert = false
    
    var body: some View {
//        NavigationView {
        VStack {
            if !editTodo {
                HStack {
                    Button("溜了"){
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                    
                    Text(presentationMode.wrappedValue.isPresented ? "添加任务" : "溜溜球")
                    
                    Spacer()
                    
                    Button("好了"){
                        okAndSave()
                    }
                }
                .padding([.horizontal, .top])
            }
            
            List {
                Group {
                    Section("基本信息") {
                        FakeIconEditor(real: $todo.icon.real, show: $todo.icon.show, color: $colorTemp, title: "图标")
                        FakeStringEditor(real: $todo.name.real, show: $todo.name.show, title: "名称", editContent: editTodo)
                        FakeStringEditor(real: $todo.detail.real, show: $todo.detail.show, title: "描述", editContent: editTodo)
                        
                        HStack{
                            Text("频率")
                                .frame(width: 40)
                            Divider()
                            
                            Picker("频率", selection: $frequency) {
                                ForEach(Todo.Frequency.allCases){ fre in 
                                    Text(fre.rawValue.capitalized)
                                }
                                Divider()
//                                Text("haha")
                            }
                            .pickerStyle(.menu)
                            .padding(.leading, 3)
                            
//                            Text("\(Todo.Frequency.allCases)")
                        }
                        
                        
                        DatePicker("始于", selection: $todo.startDate)
                            .padding(.leading, 3)
                            .datePickerStyle(.automatic)
                        
                        Toggle(isOn: $todo.hasEnding) {
                            Text("截止")
                                .frame(width: 40)
                            Text(todo.hasEnding ? "有盼头" : "无尽头")
                                .padding(.leading,10)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        if todo.hasEnding {
                            DatePicker("止于", selection: $todo.endDate)
                                .datePickerStyle(.automatic)
                                .padding(.leading, 3)
                        }
                    }
//                    .sheet(isPresented: $picking, onDismiss: {}, content: {
//                        ForEach(Todo.Frequency.allCases){ fre in
//                            Text(fre.rawValue.capitalized)
//                        }
//                    })
                    
                    Section("子任务"){
//                        NavigationView {
                            ForEach(todo.todoSub){ sub in
//                                NavigationLink(destination: TodoSubAdd(todoSub: $todoSub, addingSub: $addingSub, todo:todo), isActive: $addingSub) {
                                Button {
//                                    todoSub = sub
                                    addFakeString = true
                                    editNow = todo.todoSub.firstIndex(where: {$0.id == sub.id}) ?? 0
                                    addingSub = true
                                } label: {
                                    Text(sub.name.value(false))
                                        .padding(.leading, 3)
//                                    Text(sub.id)
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                                .buttonStyle(.borderless)
                                
//                                }
                            }
                            .onDelete(perform: deleteSub)
                            
                            Button {
                                //                            todo.todoSub.remove(at: 0)
//                                todoSub = TodoSub.empty
                                addFakeString = false
                                editNow = -1
                                addingSub = true
                            } label: {
                                Label("new",systemImage: "plus.circle")
                            }
//                            .padding(0)
//                        }
//                        .navigationViewStyle(.stack)
                    }
                    
                    if editTodo {
                        Section {
                            Button {
                                okAndSave()
                            } label: {
                                Text("保存改动")
                            }
//                            .buttonStyle(.plain)
                            Button {
                                //delete
                                deleteAlert = true
                            } label: {
                                Label("删除Todo",systemImage: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .labelStyle(.titleOnly)
                            }
                            .confirmationDialog("Are you sure?", isPresented: $deleteAlert, actions: {
                                Button("删除",role: .destructive){deleteThisTodo()}
                            }, message: {Text("确定删除此Todo？")})
                        } header: {
                            Text("改动")
                        }
                    }
                }
            }
            
            TodoRow(todo: todo,onlyForShow: true)
//                .environmentObject(UserSetting(show: false))
                .padding(.horizontal, 20)
//                .frame(width: 340+2*20) //这个只能让预览在iPhone中适合（仅测试了俺的13）需要一个尺寸方案使得在iPad甚至是ipad的各种比例下也能正确显示 遂有了下面这行 至少在目前测试中（13、ipad四个横屏比例）都能显示 还剩ipad竖屏三个比例不适配。 pro plus 手机未测试
                .frame(maxWidth: (horizontalSizeClass == .compact ? 2000 : 320), maxHeight: (userSetting.showShortTodoRow ? 60 : 100))
        }
//        .onChange(of: presentationMode.wrappedValue) { value in
//            
//        }
        .onChange(of: colorTemp, perform: { newColor in
            todo.iconColor = newColor
        })
        .onAppear(perform: {
            colorTemp = todo.iconColor
        })
        .onDisappear(perform: {
            
        })
        
        .sheet(isPresented: $addingSub,onDismiss: {addFakeString = false}) {
            TodoSubAdd(addingSub: $addingSub, todo:todo, addFakeString: addFakeString, editNow: editNow)
        }
        
    }
    
//    }
    
    func deleteSub(offsets: IndexSet){
        if todo.todoSub.count == 1 {
            return
        }
        if todo.todoSubSelection == 0 {}
        withAnimation(.default){
//            offsets.map{ todo.todoSub[$0] }.forEach(viewContext.dele)
            todo.todoSub.remove(atOffsets: offsets)
        }
    }
    
    func okAndSave() {
        // check empty ?
        for fstring in [todo.name,todo.detail,todo.icon] {
            fstring.checkNone()
        }
        if editTodo {
//            todoModel.save()
        } else {
            let todoNew = Todo(icon: todo.icon, iconColor: colorTemp, name: todo.name, showFakeString: false, detail: todo.detail, creationDate: Date(), hasEnding: todo.hasEnding, endDate: todo.endDate, todoSub: todo.todoSub, frequency: frequency).copy()
            todoModel.addTodo(todo: todoNew)
            
//            todo = Todo.template.copy()
            presentationMode.wrappedValue.dismiss()
        }
        todoModel.save(dataFileName: .Todos)
        
    }
    
    func deleteThisTodo() {
        guard let index = todoModel.todos.firstIndex(where: {todo.id == $0.id}) else {fatalError("删除当前todo时出错")}
        todoModel.todos.remove(at: index)
        todoModel.todosDict[todo.id] = nil
        todoModel.todosRecord[todo.id] = nil
        todoModel.save(dataFileName: .Todos)
    }
}

//struct TodoAdd_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoAdd()
//    }
//}
