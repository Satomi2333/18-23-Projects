import Foundation

class TodoModel: Codable, ObservableObject {
    @Published var todos: [Todo] = []
    @Published var records: [Record] = []
    var todosDict : [String:Todo] = [:] //启动时初始化 添加todo时添加
    var todosRecord: [String:[Record]] = [:] //同理
    var todoSubsDict: [String:TodoSub] = [:]
    var todoSubsRecord: [String:[Record]] = [:]
    
    enum saveFileName: String, CaseIterable{
        case Todos
        case Records
    }
    
    private enum CodingKeys: String, CodingKey {
        case todos,records
    }
    
    // The archived file name, name saved to Documents folder.
//    private let dataFileName = "Todos"
    
//    deinit(){print("todoModel has been deinit")}
    
    init() {
        // Load the data model from the 'Products' data file found in the Documents directory.
        if let codedData = try? Data(contentsOf: dataModelURL(dataFileName: .Todos)) {
//            fatalError("read todos from document")
            // Decode the json file into a DataModel object.
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decoded = try? decoder.decode([Todo].self, from: codedData) {
                todos = decoded
            }
        } else {
//            fatalError("read todos from json")
            // No data on disk, read the products from json file.
            todos = Bundle.main.decode("todos.json",toReturn: Todo.self)
            save(dataFileName: .Todos)
        }
        
        if let codedData = try? Data(contentsOf: dataModelURL(dataFileName: .Records)) {
            // Decode the json file into a DataModel object.
//            fatalError("read records from document")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decoded = try? decoder.decode([Record].self, from: codedData) {
                records = decoded
            } else {
                print("cant decode records")
                print(String(data: codedData, encoding: .utf8)!)
            }
        } else {
//            fatalError("read records from json")
            // No data on disk, read the products from json file.
            records = Bundle.main.decode("records.json", toReturn: Record.self)
            save(dataFileName: .Records)
        }
        
        // init the todoId:todo dict
        // init the todoSubId:todoSub dict
        
        initDicts()
    }
    
    func initDicts(){
        todosDict = [:]
        todosRecord = [:]
        todoSubsDict = [:]
        todoSubsRecord = [:]
        initTodosDicts()
        calcTimes()
        initTodosRecord()
    }
    
    func initTodosDicts(){
        for todo in todos {
            todosDict[todo.id] = todo 
            todosRecord[todo.id] = []
            for sub in todo.todoSub {
                todoSubsDict[sub.id] = sub
                todoSubsRecord[sub.id] = []
            }
        }
        todosDict["screenTime"] = Todo(icon: .random(), iconColor: .random(), name: .init("App"), showFakeString: false, detail: .init(""), creationDate: Date())
    }
    
    func addTodo(todo todoNew: Todo){
        todos.append(todoNew)
        todosDict[todoNew.id] = todoNew
        todosRecord[todoNew.id] = []
        for sub in todoNew.todoSub {
            todoSubsDict[sub.id] = sub
            todoSubsRecord[sub.id] = []
        }
    }
    
    func initTodosRecord(){
        for record in records {
            todosRecord[record.belongsTodo]?.append(record)
            
            guard var todoSubV = todoSubsRecord[record.belongsTodoSub] else {continue}
            todoSubV.append(record)
//            todoSubsRecord[record.belongsTodoSub]?.append(record)
            
            // 此处可能会有小问题 因为如果存在一个 belongsTodo(Sub)的指向对象不存在的Record 那么就会 nil.append 那么要保证删除todo或者todosub时删去对应记录 同时对于一个因达成目标而被移除的记录做适当的处理
            
        }
    }
    
    func updateTodoByRecord(id: String, idSub: String, spentTime: Int, times: Int, record: Record){
        // 传入的spentTime为正时 添加record 为负时 删除record
        var todayAdd = record.value
        var spentTimeToday = spentTime
        todosDict[id]?.spentTime += spentTime
        todosDict[id]?.finishedTimes += times
        if record.startTime.compare(.isToday) || record.endTime.compare(.isToday){}
        else {
            todayAdd = 0
            spentTimeToday = 0
        }
        //todoSubsDict[idSub]?.newestRecordTime = Date()
        // 使用了这个虽然可以让row里面的排序发生正确的变化
        // 但是同时变化又是实时的 会在打卡界面就跳了 
        // 比如在2里面打的 但是排名变成0了 所以就会跳到新的2里面 或者说会留在2里面
        // 所以需要跟踪当前项目的新位置 (懒得写了哈哈哈)
        if spentTime >= 0{
            todosRecord[id]?.append(record)
            todoSubsRecord[idSub]?.append(record)
            todoSubsDict[idSub]?.statistics.tempValueTotal += record.value
            todoSubsDict[idSub]?.statistics.tempValueToday += todayAdd
            todoSubsDict[idSub]?.statistics.tempTimeToday += spentTimeToday
            todoSubsDict[idSub]?.statistics.tempTimeTotal += spentTime
        } else {
            todosRecord[id]?.removeAll(where: {record.id == $0.id})
            todoSubsRecord[idSub]?.removeAll(where: {record.id == $0.id})
            todoSubsDict[idSub]?.statistics.tempValueTotal -= record.value
            todoSubsDict[idSub]?.statistics.tempValueToday -= todayAdd
            todoSubsDict[idSub]?.statistics.tempTimeToday -= spentTimeToday
            todoSubsDict[idSub]?.statistics.tempTimeTotal -= spentTime
        }
    }
    
    func calcTimes() {
        for (_, sub) in todoSubsDict {
            sub.statistics.tempValueToday = 0
            sub.statistics.tempValueTotal = sub.statistics.value
            sub.statistics.tempTimeToday = 0
            sub.statistics.tempTimeTotal = 0
        }
        var temp : [String:[Int]] = [:] //[todoid:[times, spentTime]
        for record in records {
            if temp[record.belongsTodo] != nil {
                temp[record.belongsTodo]?[0] += 1
                temp[record.belongsTodo]?[1] += record.endTime - record.startTime //extention Date - 运算符
            } else {
                temp[record.belongsTodo] = [1, record.endTime - record.startTime]
            }
            todoSubsDict[record.belongsTodoSub]?.statistics.tempValueTotal += record.value
            todoSubsDict[record.belongsTodoSub]?.statistics.tempTimeTotal += record.endTime - record.startTime
            if record.startTime.compare(.isToday) || record.endTime.compare(.isToday) {
                todoSubsDict[record.belongsTodoSub]?.statistics.tempValueToday += record.value
                todoSubsDict[record.belongsTodoSub]?.statistics.tempTimeToday += record.endTime - record.startTime
            }
            if ((todoSubsDict[record.belongsTodoSub]?.newestRecordTime.compare(.isEarlier(than: record.endTime))) != nil){
                todoSubsDict[record.belongsTodoSub]?.newestRecordTime = record.endTime
            }
            
        }
        for (todoId,values) in temp {
            todosDict[todoId]?.finishedTimes = values[0]
            todosDict[todoId]?.spentTime = values[1]
        }
    }
    
    // MARK: - Codable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(todos, forKey: .todos)
        try container.encode(records, forKey: .records)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        todos = try values.decode(Array.self, forKey: .todos)
        records = try values.decode(Array.self, forKey: .records)
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func dataModelURL(dataFileName: saveFileName) -> URL {
        let docURL = documentsDirectory()
        return docURL.appendingPathComponent(dataFileName.rawValue)
    }
    
    func importFromJSON(jsonString: String, toSave: saveFileName) -> Bool {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let codedData = jsonString.data(using: .utf8)!
        switch toSave {
        case .Todos:
            if let decoded = try? decoder.decode([Todo].self, from: codedData) {
                todos = decoded
            } else {
                return false
            }
        case .Records:
            if let decoded = try? decoder.decode([Record].self, from: codedData) {
                records = decoded
            } else {
                return false
            }
        }
        return true
    }
    
    func save(dataFileName: saveFileName) {
        let encoder = JSONEncoder()
//        if dataFileName != .Todos {
            encoder.dateEncodingStrategy = .iso8601
//        }
        
        do {
            switch dataFileName {
            case .Todos:
                let encoded = try encoder.encode(todos)
                try encoded.write(to: dataModelURL(dataFileName: dataFileName))
            case .Records:
                let encoded = try encoder.encode(records)
                try encoded.write(to: dataModelURL(dataFileName: dataFileName))
            }
        } catch {
            print("Couldn't write to save file: " + error.localizedDescription)
        }
        
//        if let encoded = try? encoder.encode(todos) {//这里这个todos让我debug了一下午 从文件保存路径开始检查 结果都是只能读写todo而不能读record 更要命的是两个文件读出来显示都是todo的内容 后面debug时选择性输出 我甚至怀疑枚举值的判断不按常理出牌
//            do {
//                // Save the 'Products' data file to the Documents directory.
//                try encoded.write(to: dataModelURL(dataFileName: dataFileName))
//            } catch {
//                print("Couldn't write to save file: " + error.localizedDescription)
//            }
//        }
    }
    
    func saveAll() {
        for name in saveFileName.allCases {
            save(dataFileName: name)
        }
    }
    
    func exportAsData(for what: saveFileName) -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        switch what {
        case .Todos:
            let encoded = (try? encoder.encode(todos))!
            return encoded
        case .Records:
            let encoded = (try? encoder.encode(records))!
            return encoded
        }
    }
    
    func export(for what: saveFileName) -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        switch what {
        case .Todos:
            let encoded = (try? encoder.encode(todos))!
            print("todos json:")
//            print(String(data: encoded, encoding: .utf8)!)
            return String(data: encoded, encoding: .utf8)!
        case .Records:
            let encoded = (try? encoder.encode(records))!
            print("records json:")
//            print(String(data: encoded, encoding: .utf8)!)
            return String(data: encoded, encoding: .utf8)!
        }
    }
}

// MARK: Bundle

extension Bundle {
    func decode<T: Decodable>(_ file: String, toReturn: T.Type) -> [T] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
//        if file != "todos.json"{
            decoder.dateDecodingStrategy = .iso8601
//        }
        guard let loaded = try? decoder.decode([T].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        print("load from json \(file)")
        return loaded
//        
//        switch file {
//        case "todos.json":
//            guard let loaded = try? decoder.decode([toReturn].self, from: data) else {
//                fatalError("Failed to decode \(file) from bundle.")
//            }
//            return loaded
//        case "records.json":
//            guard let loaded = try? decoder.decode([toReturn].self, from: data) else {
//                fatalError("Failed to decode \(file) from bundle.")
//            }
//            return loaded
//        default:fatalError("Failed to decode \(file) from bundle")
//        }
    }
}
