import SwiftUI

class Todo: ObservableObject, Identifiable, Codable {
    var id : String
    @Published var icon: FakeString
    @Published var iconColor: MyColor
    @Published var name: FakeString
    var showFakeString: Bool = false
    @Published var detail: FakeString
    var onlyShowTimes: Bool = false
    @Published var finishedTimes: Int = 0
    @Published var spentTime: Int = 0
    @Published var creationDate: Date = Date()
    @Published var startDate: Date = Date()
    @Published var hasEnding: Bool = true
    @Published var endDate: Date = Date()
    @Published var todoSub: [TodoSub] = [.empty]//TodoSub.random(count: 3) //[.test]
    @Published var todoSubSelection = 0
    @Published var pinned: Bool = false
    var frequency: Frequency = .daily
    var repeatDays: [Date] = [Date()]
    var doItToday: Bool {
        switch frequency{
            case .weekdays: return false
            case .weekends: return false
        default: return true
        }
//        return true
    }
    
    var todoSubSorted: [TodoSub] {
        return todoSub.sorted(by: {(r, rr) -> Bool in
            return r.newestRecordTime.isAfterDate(rr.newestRecordTime, granularity: .day)
        })
    }
    
    enum Frequency: String, Codable, CaseIterable, Identifiable {
        case daily
        case weekdays
        case weekends
        case weekly
        case biweekly
        case monthly
        case yearly
        var id: Self {self}
    }
//    static let FrequencySting = ["daily","weekdays","weekends","weekly","biweekly","monthly","yearly"]
    
    //MARK: - Codabel
    private enum CoderKeys: String, CodingKey {
        case id,icon,iconColor,name,detail,onlyShowTimes,finishedTimes,spentTime,creationDate,startDate,hasEnding,endDate,todoSub,todoSubSelection,pinned,frequency,repeatDays
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(icon, forKey: .icon)
        try container.encode(iconColor, forKey: .iconColor)
        try container.encode(name, forKey: .name)
        try container.encode(detail, forKey: .detail)
        try container.encode(onlyShowTimes, forKey: .onlyShowTimes)
        try container.encode(0, forKey: .finishedTimes)
        try container.encode(0, forKey: .spentTime)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(hasEnding, forKey: .hasEnding)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(todoSub, forKey: .todoSub)
        try container.encode(todoSubSelection, forKey: .todoSubSelection)
        try container.encode(pinned, forKey: .pinned)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(repeatDays, forKey: .repeatDays)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        id = try values.decode(String.self, forKey: .id)
        icon = try values.decode(FakeString.self, forKey: .icon)
        iconColor = try values.decode(MyColor.self, forKey: .iconColor)
        name = try values.decode(FakeString.self, forKey: .name)
        detail = try values.decode(FakeString.self, forKey: .detail)
        onlyShowTimes = try values.decode(Bool.self, forKey: .onlyShowTimes)
        finishedTimes = try values.decode(Int.self, forKey: .finishedTimes)
        spentTime = try values.decode(Int.self, forKey: .spentTime)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        startDate = try values.decode(Date.self, forKey: .startDate)
        hasEnding = try values.decode(Bool.self, forKey: .hasEnding)
        endDate = try values.decode(Date.self, forKey: .endDate)
        todoSub = try values.decode([TodoSub].self, forKey: .todoSub)
        todoSubSelection = try values.decode(Int.self, forKey: .todoSubSelection)
        pinned = try values.decode(Bool.self, forKey: .pinned)
        frequency = try values.decode(Frequency.self, forKey: .frequency)
        repeatDays = try values.decode([Date].self, forKey: .repeatDays)
    }
    
    init(icon i: FakeString, iconColor ic: MyColor, name n: FakeString, showFakeString sfs: Bool?, detail d: FakeString, creationDate cT: Date, hasEnding end: Bool? = false, endDate eT: Date? = Date(), todoSub sub: [TodoSub]? = [.empty] ,frequency f: Frequency? = .daily) {
        self.id = "\(cT)"+"\(n.show)\(n.real)"
        self.iconColor = ic
        self.icon = i
        self.name = n
        self.showFakeString = sfs ?? false
        self.detail = d
        self.creationDate = cT
        self.hasEnding = end ?? false
        self.endDate = eT ?? Date()
        self.todoSub = sub ?? [.empty]
        self.frequency = f ?? .daily
    }
    
    func finishOnce(){
        
    }
    
    func copy() -> Self {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            fatalError("decode failed")
        }
        let decoder = JSONDecoder()
        guard let new = try? decoder.decode(Self.self, from: data) else {
            fatalError("encode failed")
        }
        return new
    }
    
    func testOnly() -> Todo{
        finishedTimes += Int.random(in: 3...10)
        spentTime += Int.random(in: 60...120)
        return self
    }
    
    static func random() -> Todo {
        return Todo(icon: .random(length: 0, icon: true), iconColor: .random(), name: .random(length: 5), showFakeString: true, detail: .random(length: 50), creationDate: Date())
    }
    
    static func random(count: Int = 10) -> [Todo] {
        var todos:[Todo] = []
        for _ in 0..<count {
            todos.append(Todo.random())
        }
        return todos
    }
    
    static let test = Todo(icon: FakeString(show: "book", real: "hands.clap"), iconColor: .random(), name: FakeString(show: "阅读", real: "冲！"), showFakeString: false, detail: FakeString(show: "每天都要记得读书哦～后面就是废话了，用来测试截断用的，也不知道什么时候截断", real: "刚才那是一个虚假的表面") , creationDate: Date())
    
    static func template() -> Todo {
        return Todo(icon: FakeString(show: "book", real: ""), iconColor: .random(), name: FakeString(show: "做什么？", real: ""), showFakeString: false, detail: FakeString(show: "关于这个Todo有什么描述？", real: ""), creationDate: Date(), todoSub: [TodoSub(name: FakeString(show: "1",real: ""), statistics: Statistics(value: 0, unitDescription: FakeString(""), description: FakeString(""), endless: true, endValue: -1))])
    }
    
    //static var template = Todo(icon: FakeString(show: "book", real: ""), iconColor: .random(), name: FakeString(show: "做什么？", real: ""), showFakeString: false, detail: FakeString(show: "关于这个Todo有什么描述？", real: ""), creationDate: Date(), todoSub: [TodoSub(name: FakeString(show: "1",real: ""), statistics: Statistics(value: 0, unitDescription: FakeString(""), description: FakeString(""), endless: true, endValue: -1))])
    //后来发现每个从template创建的todo 他们的第一个todosub都有着相同的id 
    
    static let unknown = Todo(icon: .random(), iconColor: .random(), name: .init("?"), showFakeString: false, detail: .init("??"), creationDate: Date())
}

