import SwiftUI

let debug = false

struct TodoSubAdd: View {
#if debug
//    @State var todoSub = TodoSub.test
//    var addingSub = false
#else
//    var todoSub: TodoSub
    @Binding var addingSub: Bool
    @EnvironmentObject var todoModel : TodoModel
    @ObservedObject var todo: Todo
#endif
    @StateObject var name = FakeString(show: "", real: "")
    @StateObject var description = FakeString("")
    @StateObject var unitDescription = FakeString("")
    @State var valueTemp = "0"
    @State var endValueTemp = "100"
    @State var endlessTemp = false
    @State var exiting = false
    @State var addFakeString: Bool
    var editNow: Int
    
    var todoSub: TodoSub{
        if editNow == -1 {
            return TodoSub.empty
        } else {
            return todo.todoSub[editNow]
        }
    }
    
    var testInt: Int {
        do {
            let value = try Int(valueTemp, format: .number)
            return value
        } catch {
            return -1
        }
    }
    
    var testIntEnd: Int {
        do {
            let value = try Int(endValueTemp, format: .number)
            return value
        } catch {
            return -1
        }
    }
    
    var isValid: Bool {
        return testInt >= 0 ? true : false
    }
    
    var endValuIsValid: Bool {
        return testIntEnd > 0 ? true : false
    }
    
    @State var stringNotNull = true
    //其实子任务名称为空的话自动分配就可以了 检查起来有点麻烦
    
//    var stringNotNull: Bool {
//        return todoSub.name.notNil
//        //return (todoSub.name.notNil && todoSub.statistics.description.notNil)
//    }
    
    var everythingOk: Bool {
        return ((isValid && endlessTemp) || (isValid && !endlessTemp && endValuIsValid)) && stringNotNull
    }
    
    var body: some View {
        VStack{
            HStack{
                Button("溜了"){
//                    addingSub = false
                    exiting = true
                }
                .padding([.top, .leading])
                .alert(isPresented: $exiting) {
                    let a = Alert(title: Text("不保存就开溜？"),
                                  primaryButton: .default(Text("我再看看"), action: {}), 
                                  secondaryButton: .destructive(Text("倔强开溜"), action: {
                        addingSub = false
                    }))
                    return a
                }
                
                Spacer()
                
                Text("编辑子任务")
                    .padding(.top)
                
                Spacer()
                Button("好了"){
//                    todoSub = nil
//                    addingSub = false
                    if everythingOk {
//                        print("ok")
                        for fstring in [name,description,unitDescription] {
                            fstring.checkNone()
                        }
                        let sta = Statistics(value: testInt, unitDescription: unitDescription, description: description, endless: endlessTemp, endValue: (endlessTemp ? -1 : testIntEnd))
                        let sub = TodoSub(name: name, statistics: sta)
//                        todoSub = sub
                        if addFakeString {
//                            todoSub = sub
                            sub.id = todoSub.id
                            todo.todoSub[editNow] = sub
                        } else {
                            todo.todoSub.append(sub)
                        }
                        todoModel.todoSubsDict[sub.id] = sub
                        addingSub = false
                    } else {
                        exiting = true
                    }
                }
                .disabled(!everythingOk)
                .padding([.top, .trailing])
                .alert(isPresented: $exiting) {
                    let a = Alert(title: Text("数据格式不正确"), 
//                                  message: Text("not good"), 
                                  primaryButton: .default(Text("返回编辑"), action: {}), 
                                  secondaryButton: .destructive(Text("离开不保存"), action: {
                        addingSub = false
                    }))
                    return a
                }
            }
            List{
                Group{
                    Section("模版（点击可以快速填入）") {
                        
                            ForEach(Statistics.templates){ sta in
                                Button{
//                                    todoSub.statistics = sta
                                    description.show = sta.description.show
                                    description.real = sta.description.real
                                    unitDescription.show = sta.unitDescription.show
                                    unitDescription.real = sta.unitDescription.real
                                    endValueTemp = String(sta.endValue)
                                    endlessTemp = sta.endless
                                } label: {
                                    sta.getDescriptionView()}
                            }
                        //TODO: save current as template
                        //TODO: delete template item
                    }
                    Section("基本信息") {
                        HStack {
                            FakeStringEditor(real: $name.real, show: $name.show, title: "名称", editContent: addFakeString)
//                                .onChange(of: todoSub.name.real, perform: {newValue in
//                                    stringNotNull = todoSub.name.notNil
//                                    print(stringNotNull)
//                                })
                                
                            if !stringNotNull {
                                Label("",systemImage: "xmark.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.red)
                            }
                        }
//                        .onChange(of: todoSub.name.real, perform: { _ in
//                            print("changed!")
//                        })
                        
                        FakeStringEditor(real: $description.real, show: $description.show, title: "描述", editContent: addFakeString)
                        
                        HStack{
                            Text("初值")
                                .frame(width: 40)
                            Divider()
                            TextField("初始值", text: $valueTemp)
                                .keyboardType(.numberPad)
                                .padding(.leading, 5)
                            Spacer()
                            
                            if !isValid {
                                Label("", systemImage: "xmark.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.red)
                            }
                            else {
                                Text("\(testInt)")
                            }
                        }
                        
                        FakeStringEditor(real: $unitDescription.real, show: $unitDescription.show, title: "单位",editContent: addFakeString)
                        
                        Toggle(isOn: $endlessTemp) {
                            Text("无尽")
                                .padding(.leading, 3)
                        }
                        
                        if !endlessTemp {
                            withAnimation(){
                                HStack {
                                    Text("终值")
                                        .frame(width: 40)
                                    Divider()
                                    TextField("目标值", text: $endValueTemp)
                                        .keyboardType(.numberPad)
                                        .padding(.leading, 5)
                                    if !endValuIsValid {
                                        Label("", systemImage: "xmark.circle.fill")
                                            .labelStyle(.iconOnly)
                                            .foregroundColor(.red)
                                    }
                                    else {
                                        Text("\(testIntEnd)")
                                    }
                                }
                                .animation(.easeInOut, value: endlessTemp)
                            }
                        }
                    }
                }
            }
            //.padding()
            .background(.bar)
        }
        .onAppear(perform: {
            name.real = todoSub.name.real
            name.show = todoSub.name.show  
            unitDescription.real = todoSub.statistics.unitDescription.real
            unitDescription.show = todoSub.statistics.unitDescription.show
            description.real = todoSub.statistics.description.real
            description.show = todoSub.statistics.description.show
            valueTemp = String(todoSub.statistics.value)
            endValueTemp = String(todoSub.statistics.endValue)
            endlessTemp = todoSub.statistics.endless
        })
    }
}

#if debug
//struct TodoSubAdd_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoSubAdd()
//    }
//}
#endif
