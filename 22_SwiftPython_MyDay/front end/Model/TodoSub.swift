import SwiftUI

class TodoSub: Identifiable, Codable, ObservableObject {
    var id : String
    var name: FakeString
    var creationDate = Date()
    var statistics: Statistics
    var newestRecordTime: Date
    
    enum CodingKeys: String, CodingKey{
        case id, name, creationDate, statistics
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(FakeString.self, forKey: .name)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        statistics = try container.decode(Statistics.self, forKey: .statistics)
        newestRecordTime = creationDate
    }
    
    init(name n: FakeString, statistics s: Statistics){
        id = "\(creationDate)"+"\(n.real)\(n.show)"
        name = n
        statistics = s
        newestRecordTime = creationDate
    }
    
    static func random() -> TodoSub {
        return TodoSub(name: .random(length: 3), statistics: .random()) 
    }
    
    static func random(count: Int = 1) -> [TodoSub]{
        var temp: [TodoSub] = []
        for _ in 0..<count {
            temp.append(.random())
        }
        return temp
    }
    
    static var empty = TodoSub(name: FakeString(show: "子任务", real: "真正的"), statistics: .empty)
    
    static var test = TodoSub(name: FakeString(show: "论文", real: "paper"), statistics: .paper)
    
    static let unknown = TodoSub(name: .init("?"), statistics: .empty)
    
    static var tests = [TodoSub(name: FakeString(show: "书", real: "book"), statistics: .book),
                         TodoSub(name: FakeString(show: "喝水", real: "drink"), statistics: .drink),
                        TodoSub(name: FakeString(show: "论文", real: "paper"), statistics: .paper)
    ]
}
