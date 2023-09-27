import SwiftUI

class Statistics: Codable, Identifiable {
    var id : String
    var value: Int // init value / start value
    var unitDescription: FakeString
    var description: FakeString
    var endless: Bool
    var endValue: Int
    var tempValueTotal = 0 // 这两个值不保存 每次启动时重新计算
    var tempValueToday = 0 // 且每次记录变更时更新
    var tempTimeToday = 0
    var tempTimeTotal = 0
    
    enum CodingKeys: String, CodingKey{
        case id, value, unitDescription, description, endless, endValue
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        value = try container.decode(Int.self, forKey: .value)
        unitDescription = try container.decode(FakeString.self, forKey: .unitDescription)
        description = try container.decode(FakeString.self, forKey: .description)
        endless = try container.decode(Bool.self, forKey: .endless)
        endValue = try container.decode(Int.self, forKey: .endValue)
        tempValueToday = 0
        tempValueTotal = 0
        tempTimeToday = 0
        tempTimeTotal = 0
    }
    
    init(value v: Int, unitDescription unitDes: FakeString, description des: FakeString, endless e: Bool? = true, endValue ev: Int? = -1){
        id = "\(Date())\(des.show)\(des.real)"
        value = v
        unitDescription = unitDes
        description = des
        endless = e!
        endValue = ev!
        tempValueToday = 0
        tempValueTotal = 0
        tempTimeToday = 0
        tempTimeTotal = 0
    }
    
    func addValue(value: Int) {
        self.value += value
    }
    
    var isEnd : Bool {
        if endless {return false}
        else {
            return tempValueTotal >= endValue
        }
    }
    
    func getDescription(today: Bool, _ showReal: Bool = false, _ showDescription : Bool = true) -> String {
        if endless {
            return today ? "\(showDescription ? description.value(showReal) : "")今日 \(tempValueToday) \(unitDescription.value(showReal))，\(Int.toHour(tempTimeToday))" : "总计 \(tempValueTotal) \(unitDescription.value(showReal))，\(Int.toHour(tempTimeTotal))"
        } else {
            return today ? "\(showDescription ? description.value(showReal) : "")今日 \(tempValueToday) \(unitDescription.value(showReal))，\(Int.toHour(tempTimeToday))" : "总计 \(tempValueTotal)/\(endValue) \(unitDescription.value(showReal))，\(Int.toHour(tempTimeTotal))"
        }
    }
    
    func getDescriptionView() -> some View {
        return VStack(alignment:.trailing){
            Text(getDescription(today: true))
            Text(getDescription(today: false))
        }
    }
    
    static func random() -> Statistics {
        let endless = Bool.random()
        return Statistics(value: .random(in: 0...20), unitDescription: .random(), description: .random(length: 8), endless: endless, endValue: .random(in: 20...100))
    }
    
    static func random(count: Int = 1) -> [Statistics]{
        var temp: [Statistics] = []
        for _ in 0..<count {
            temp.append(.random())
        }
        return temp
    }
    
    static var drink: Statistics = Statistics(value: 0, unitDescription:FakeString(show: "毫升", real: "ml"), description: FakeString(show: "饮水量：",real: "奶茶量："))
    static var book: Statistics = Statistics(value: 0, unitDescription: FakeString(show: "页",real: "集"), description: FakeString(show: "书籍阅读量：",real: "阅片无数："), endless: false, endValue: 100)
    static var paper = Statistics(value: 0, unitDescription: FakeString(show: "篇",real: "部"), description: FakeString(show: "文章阅读量：",real: "B站观看量："))
    static var empty = Statistics(value: 0, unitDescription: FakeString(show: "本、页之类的", real: "真正的"), description: FakeString(show: "阅读量：" ,real: "正真的："))
    
    static var count = Statistics(value: 0, unitDescription: FakeString(show: "次", real: ""), description: FakeString(show: "次数：", real: ""))
    static var course = Statistics(value: 0, unitDescription: FakeString(show: "节", real: ""), description: FakeString(show: "课时：", real: ""), endless: false, endValue: 36)
    static var bangumi = Statistics(value: 0, unitDescription: FakeString(show: "话", real: ""), description: FakeString(show: "番剧：", real: ""), endless: false, endValue: 13)
    static var book1 = Statistics(value: 0, unitDescription: FakeString(show: "页", real: ""), description: FakeString(show: "看书：", real: ""))
    
    static var templates: [Statistics] = [.book1, .course, .count, .bangumi]
}
