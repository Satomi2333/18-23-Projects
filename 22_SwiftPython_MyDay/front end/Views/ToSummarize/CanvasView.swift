import SwiftUI
import SwiftDate

struct MyText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .modifier(xlabel())
    }
}

struct xlabel: ViewModifier {
    func body(content: Content) -> some View {
        content
//            .font(.caption2)
            .foregroundColor(.gray.opacity(0.8))
//            .font(.system(size: 10))
            .font(.monospaced(.caption2)())
            .padding(0)
    }
}

struct CanvasView: View {
    @EnvironmentObject var todoModel: TodoModel
    @EnvironmentObject var userSetting : UserSetting
    @State var scale = 1.0
//    @State var initWidth = 10.0
//    @State var wOri = 100.0
    @Environment(\.colorScheme) var colorScheme
//    @Binding var scale: Double
    let text0to24 = ["00","02","04","06","08","10","12","14","16","18","20","22","24"]
    @State var recordsNow : [Record] = Record.records
    @State var dayToShow = Date()
    @State var todoRecordDict : [String:[Record]] = [:]
    @State var todoRecordDictNow : [String:[Record]] = [:]
    let servers = ["http://192.168.1.1:5001/"]
    @State var serversSelection = 0
    //var todosRecordSpecifyDay : [String:[Record]]{
    //for (_,record) in recordDict {
    //let todoNow = todoModel.todosDict[record.belongsTodo]
    ////todosRecordSpecifyDay[todoNow.id]?.append(record)
    //}
    //return [:]
    //}
//    @State var screenTimeDictGroupedBySource: [String:[String:[Record]]] = [:] // "iphone":["qq":[Record],"wechat":[R]] //this var cant be as @State, otherwise something magicial gonna happen
    
    @State var screenTimeDictGroupedBySource: [String:[String:[Record]]] = [:] // "iphone":["qq":[Record],"wechat":[R]] //but finally this var has to be @State. But it only be accessed when date change, not every time when canvas refresh
    @State var countOfScreenTimeRecord = 0
    @State var showRoundDot = false
    
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = value
            }
            .onEnded{ value in
                scale = value
            }
    }
    
    func getAllRecordFromSpecifyDay(start: DateInRegion, end: DateInRegion) async {
        //todosRecordSpecifyDay = [:]
        let fetcher = Fetcher()
        fetcher.serverUrl = userSetting.serverUrl
        let body = PostBody.toData(me: RecordDayBody(start: start, end: end))
//        print(String(data: body, encoding: .utf8))
        let action = Fetcher.Actions(url: "record/allFromDay", method: .POST, body: body)
        try? await fetcher.httpRequest(actions: action, doNext: { data in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
//            do {
//                let returnedTodoRecord = try decoder.decode(ReturnedTodoRecord.self, from: data)
                let returnedTodoRecord = (try? decoder.decode(ReturnedTodoRecord.self, from: data))!
//            } catch {
//                print(error)
//            }
//            return
            switch returnedTodoRecord.success {
            case 1:
                todoRecordDict = returnedTodoRecord.contents
                calcTodoRecordsAndScreenTimeRecord()
                return
            case -1:
                print("got no records in that day")
                return
            default:
                return
            }
        })
    }
    
    func calcTodoRecordsAndScreenTimeRecord() {
        lazy var todoRecordDictTemp : [String:[Record]] = [:]
        if userSetting.showRecordsOnlyNotNil{
            todoRecordDictNow = todoRecordDict
        } else {
            for (todoid,_) in todoModel.todosRecord{
                todoRecordDictTemp[todoid] = []
            }
            for (todoid,record) in todoRecordDict {
                todoRecordDictTemp[todoid] = record
            }
            todoRecordDictNow = todoRecordDictTemp
        }
        
        countOfScreenTimeRecord = 0
        for (todoId,groupedRecord) in todoRecordDictNow {
            if todoId != "screenTime"{
                continue
            } else {
                var tempGroupedBySource : [String:[Record]] = [:]
                for record in groupedRecord {
                    if (tempGroupedBySource[record.source] != nil) {
                        tempGroupedBySource[record.source]!.append(record)
                    } else {
                        tempGroupedBySource[record.source] = [record]
                    }
                }
                for (source, records) in tempGroupedBySource {
                    var tempApps : [String:[Record]] = [:]
                    for r in records {
                        if (tempApps[r.belongsTodoSub] != nil) {
                            tempApps[r.belongsTodoSub]!.append(r)
                        } else {
                            tempApps[r.belongsTodoSub] = [r]
                        }
                    }
                    screenTimeDictGroupedBySource[source] = tempApps
                    countOfScreenTimeRecord += tempApps.count
                }
            }
        }
    }
    
    var body: some View {
        VStack{
//            Text("\(todoModel.records.count)")
//            ForEach(todoModel.records){ re in
//                Text(re.belongsTodo)+Text(" - ")+Text(re.belongsTodoSub)
//            }
            Text("")
                .frame(height:0)
            //            Text("\(UIDevice.current.name)")
            DisclosureGroup(){
                TextField("deviceName", text: $userSetting.deviceName)
                    .textFieldStyle(.roundedBorder)
                TextField("serverUrl", text: $userSetting.serverUrl)
                    .textFieldStyle(.roundedBorder)
                Picker(selection: $serversSelection, label:Text("choose a server")) {
                    ForEach(Range(0...3)) { sub in
                        Text(servers[sub])
                            .frame(width: 20)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: serversSelection) { value in
                    userSetting.serverUrl = servers[value]
                }
                .onSubmit {
                    userSetting.serverUrl = servers[serversSelection]
                }
                Toggle(isOn: $userSetting.showRecordsOnlyNotNil) {
                    Text("仅展示有打卡记录的")
                }
                Toggle(isOn: $userSetting.showShortTodoRow) {
                    Text("显示简洁TodoRow")
                }
                Toggle(isOn: $showRoundDot, label: {
                    Text("显示圆圆的")
                })
                Toggle(isOn: $userSetting.sortTodoSubsByRecent) {
                    Text("子任务按最近打卡时间排序(默认按创建时间)")
                }
            } label: {
                Text("配置项")
            }.padding(.horizontal, 10)
            DatePicker("展示日期", selection: $dayToShow, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .onChange(of: dayToShow, perform: { newValue in
                    Task {
                        let start = DateInRegion(newValue, region: .UTC).dateAt(.startOfDay)
                        let end = DateInRegion(newValue, region: .UTC).dateAt(.endOfDay)
                        //let start = newValue.dateAt(.startOfDay)
                        //let end = newValue.dateAt(.endOfDay)
                        await getAllRecordFromSpecifyDay(start: start, end: end)
                    }
                })
            Slider(value: $scale, in: 1.0...3.0){
                Text("缩放")
            } minimumValueLabel: {
                Text("1.0x")
            } maximumValueLabel: {
//                Text("3.0x\(initWidth)")
                Text("3.0x")
            }
            .frame(height: 30)
            
            HStack{
//                Text("initWidth:\(initWidth)")
//                Text("wOri:\(wOri)")
            }
            
            GeometryReader { geometry in 
            ScrollView(.horizontal, showsIndicators: true){
//                ZStack {
                VStack {
//                        HStack{
                    Rectangle() //这个矩形存在的意义就是"撑场面"👻 删去的话Canvas就不能自动和视图大小匹配了
                        .frame(width: geometry.size.width*scale, height: 10, alignment: .center)
                        .padding(0)
                        .foregroundColor(colorScheme == .light ? .white : .dark)
//                            Capsule()
//                                .frame(width: 100*scale, height: 20, alignment: .center)
//                        }
//                        GeometryReader{ geometry in
                    let size = geometry.size
                    Canvas { context, _ in
                        var lines = Path()
                        let wOri = size.width / 4 //原始的宽 屏幕全宽的四分之一
                        var initWidth = wOri //为了不同比例屏幕限制后的宽
//                                w = (w > 100 ? 100 : w)
                        if initWidth > 100 {
//                                    scale = w/100
                            initWidth = 100
                        }
//                                let h = w //一开始计划是正方形 所以h=w 适配以后就用不上了
                        for i in 0...12 { //竖线
                            if i%3==0 {
                                lines.move(to: CGPoint(x: Double(i/3)*wOri*scale, y: 0.0))
                                lines.addLine(to: CGPoint(x: Double(i/3)*wOri*scale, y: initWidth*3.2))
                            } else {
                                if wOri*scale > 150 {
                                    lines.move(to: CGPoint(x: Double(i)*wOri*scale/3.0, y: 0.0))
                                    lines.addLine(to: CGPoint(x: Double(i)*wOri*scale/3.0, y: initWidth*3.1))
                                }
                            }
                        }
                        context.stroke(lines, with: .color((colorScheme == .dark ? Color.white : .black).opacity(0.2)), style: StrokeStyle(lineWidth: 0.5))
                        
                        for i in 0..<4 { //横线
                            lines.move(to: CGPoint(x: 0, y: Double(i)*initWidth))
                            lines.addLine(to: CGPoint(x: size.width*scale, y: Double(i)*initWidth))
                        }
                        //                            context.stroke(lines, with: .color(.black.opacity(0.5)), style: StrokeStyle(lineWidth: 0.5, dash: [20]))
                        
//                                context.draw(Text("test"), at: CGPoint(x: 100*scale, y: 100)) // 我靠 我苦苦搜寻文字绘制无果 只能用Text（）+ZStack强行叠加 而后竟然无意中在context中发现了这个方法
                        for i in 0..<text0to24.count { //00-24的文字
                            if i%3 == 0{
                                context.draw(
                                    Text(text0to24[i])
                                        .foregroundColor(.gray.opacity(0.8))
                                        .font(.monospaced(.caption2)())
                                    , at: CGPoint(x: Double(i)*wOri*scale/3+10, y: initWidth*3.15))
                            } else {
                                if wOri*scale > 150 {
                                    context.draw(
                                        Text(text0to24[i])
                                            .foregroundColor(.gray.opacity(0.8))
                                            .font(.monospaced(.caption2)())
                                        , at: CGPoint(x: Double(i)*wOri*scale/3+10, y: initWidth*3.15))
                                }
                            }
                            
                        }
                        
//                                //lines = Path()
//                                //for record in Record.records {
//                                for i in 0 ..< 5 { //随机颜色彩色线 画出来测试一下哈哈
//                                    lines = Path()
//                                    lines.addRoundedRect(in: CGRect(x: 50*Double(i)*scale, y: 100, width: 30*scale, height: 10), cornerSize: CGSize(width: 5, height: 5))
//                                
//                                    context.fill(lines, with: .color(.random()))
//                                }
                        
////                                for record in recordsNow {
                        //画一下Record里面内置的测试对象
//                                    let x = Date.getRelativeOfDay(date: record.startTime)
//                                    let y = Date.getRelativeOfDay(date: record.endTime)
////                                    print((y-x)*scale*initWidth*4)
//                                    lines = Path()
//                                    lines.addRoundedRect(in: CGRect(x: Double(x)*initWidth*4.0*scale, y: 50, width: max((y-x), 0.032)*scale*initWidth*4.0, height: 10), cornerSize: CGSize(width: 5, height: 5))
//                                    context.fill(lines, with: .color(.random()))
//                                }
                        // 开始画Record
                        var count = 0
                        let todoCount = todoRecordDict.count
                        let todoAllCount = todoModel.todosDict.count
//                        if userSetting.showRecordsOnlyNotNil{
//                            for (_,groupedRecord) in todoModel.todosRecord {
//                                if groupedRecord.count == 0 {
//                                    todoCount -= 1
//                                }
//                            }
//                        }
                    
                        var countNow = 1
                        for (todoId, groupedRecord) in todoRecordDictNow {
                            if todoId == "screenTime"{
                                continue
                            }
                            //let groupedFilteredRecord = groupedRecord.filter({
                            //$0.startTime.compare(.isSameDay(dayToShow)) || $0.endTime.compare(.isSameDay(dayToShow))
                            //})
//                            if userSetting.showRecordsOnlyNotNil && groupedRecord.count == 0{
//                                continue
//                            }
                            if userSetting.showRecordsOnlyNotNil {
                                countNow = todoCount
                            } else {
                                countNow = todoAllCount
                            }
//                            return 1
                            lines = Path()
                            
                            guard let todoNow : Todo = todoModel.todosDict[todoId] else {continue}
                            let todoColor : Color = todoNow.iconColor.toColor()
                            let todoName = todoNow.name.show
                            var positionOfy = initWidth*Double(count)/Double(countNow)
                            if initWidth/Double(countNow) < 10 {positionOfy *= 2}
                            for record in groupedRecord {
                                let x = Date.getRelativeOfDay(date: record.startTime)
                                let y = Date.getRelativeOfDay(date: record.endTime)
                                if showRoundDot {
                                    lines.addRoundedRect(in: CGRect(x: Double(x)*wOri*4.0*scale, y: positionOfy, width: max((y-x)*scale*wOri*4.0,10), height: 10), cornerSize: CGSize(width: 5, height: 5))
                                } else {
                                    lines.addRoundedRect(in: CGRect(x: Double(x)*wOri*4.0*scale, y: positionOfy, width: max((y-x)*scale*wOri*4.0,2), height: 10), cornerSize: CGSize(width: 1, height: 1))
                                }
                                
                            }
                            context.draw(
                                Text(todoName)
                                    .foregroundColor(.gray)
//                                            .background()
                                    .font(.caption),
                                at: CGPoint(x: 0, y: positionOfy),
                                anchor: UnitPoint(x: 0, y:0))
                            context.fill(lines, with: .color(todoColor))
                            count += 1
                        }
                        
                        //开始画screenTime
                        
//                        return 1
                        var countOfGroup = 0
                        var countOfSource = 0
                        let heightOfEachRow = initWidth/Double(countOfScreenTimeRecord)
                        for (source, appRecordDict) in screenTimeDictGroupedBySource {
                            var offSetOfY = initWidth
                            if initWidth/Double(countNow) < 10 {offSetOfY *= 2.0}
                            let positionOfy = offSetOfY+initWidth*Double(countOfGroup)/Double(countOfScreenTimeRecord)
                            
                            lines = Path()
                            lines.addRoundedRect(in: CGRect(x: 0, y: positionOfy, width: size.width*scale, height: Double(appRecordDict.count)*heightOfEachRow-5.0), cornerSize: CGSize(width: 5, height: 5))
                            context.draw(
                                Text(source)
                                    .foregroundColor(.gray.opacity(0.2))
                                    .font(.headline),
                                at: CGPoint(x: size.width*scale*0.25, y: positionOfy),
                                anchor: UnitPoint(x: 0, y:0.2))
                            context.fill(lines, with: .color(.random().opacity(0.2)))
                            
                            countOfSource += 1
                            for (app, records) in appRecordDict {
                                lines = Path()
                                let positionOfy = offSetOfY+initWidth*Double(countOfGroup)/Double(countOfScreenTimeRecord)
//                                if initWidth/Double(countOfScreenTimeRecord) < 10 {positionOfy *= 2}
                                
                                context.draw(
                                    Text(app)
                                        .foregroundColor(.gray)
                                        .font(.caption),
                                    at: CGPoint(x: 0, y: positionOfy),
                                    anchor: UnitPoint(x: 0, y:0))
                                
                                for record in records {
                                    let x = Date.getRelativeOfDay(date: record.startTime)
                                    let y = Date.getRelativeOfDay(date: record.endTime)
                                    if showRoundDot {
                                        lines.addRoundedRect(in: CGRect(x: Double(x)*wOri*4.0*scale, y: positionOfy, width: max((y-x)*scale*wOri*4.0,10), height: 10), cornerSize: CGSize(width: 5, height: 5))
                                    } else {
                                        lines.addRoundedRect(in: CGRect(x: Double(x)*wOri*4.0*scale, y: positionOfy, width: max((y-x)*scale*wOri*4.0,2), height: 10), cornerSize: CGSize(width: 1, height: 1))
                                    }
                                }
                                
                                context.fill(lines, with: .color(.random()))
                                
                                countOfGroup += 1
                            }
//                            count1 = 0
                        }
                        
                    }//Cavans
//                        }
                    }//VStack
                
//                    VStack(spacing: 0) { // 原本使用zstack来叠加00-24的字 后有更好的方法了
//                        Spacer()
//                        HStack(spacing: 0) {
////                            Text("00")
////                                .modifier(xlabel())
//                            ForEach(0 ..< text0to24.count) { i in
//                                MyText(text: text0to24[i])
//                                if i != 4 { Spacer() }
//                            }
//                        }
////                        .padding(.leading,0)
////                        .offset(CGSize(width: 5, 
////                                       height: -geometry.size.height+30+10+300))
//                    }
                    
//                }
                }//ScrollView
                
            }//GeometryReader
            
//            Spacer()
//            Text("\(recordsNow.count)")
//            Button("button"){
//                print(recordsNow.count)
//                recordsNow = Record.records
//            }
        }//VStack
        .onAppear(perform: {
            //recordsNow = Record.records
            Task {
                await getAllRecordFromSpecifyDay(start: DateInRegion(dayToShow,region: .current).dateAt(.startOfDay), end: DateInRegion(dayToShow,region: .current).dateAt(.endOfDay))
            }
        })
//        .gesture(magnification)
//        .highPriorityGesture(magnification)
//        .simultaneousGesture(magnification)
    }
}

//struct CanvasView_Previews: PreviewProvider {
//    static var previews: some View {
//        CanvasView()
////            .frame(width: 400)
////            .padding()
//            .environment(\.colorScheme, .light)
//            .environmentObject(TodoModel())
//    }
//}

