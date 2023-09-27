import SwiftUI
//import SwiftDate

class Record: ObservableObject, Codable, Identifiable {
    var id : String
    var belongsTodo : String
    var belongsTodoSub : String
    var recordTime: Date
//    var source: String
    @Published var startTime : Date
    @Published var endTime : Date
    @Published var value: Int
    var source: String = "iPhone"
    var note: String = ""
    
    private enum CodingKeys: String, CodingKey{
        case id,belongsTodo,belongsTodoSub,recordTime,startTime,endTime,value,source,note
    }
    
    static var records : [Record] = [
        Record(belongsTodo: "", belongsTodoSub: "", startTime: Date(timeIntervalSinceNow: -7200), endTime: Date(), value: 5),
        Record(belongsTodo: "", belongsTodoSub: "", startTime: Date(timeIntervalSinceNow: 3600), endTime: Date(timeIntervalSinceNow: 3601), value: 4)
    ]
    
    init(belongsTodo b: String, belongsTodoSub bs: String, startTime st: Date, endTime et: Date, value v: Int, source s: String?="this", note n: String?=""){
        id = "\(Date())\(b)\(bs)\(et-st)\(v)"
        belongsTodo = b
        belongsTodoSub = bs
        startTime = st
        endTime = et
        value = v
        recordTime = Date()
        source = s ?? "this"
        note = n ?? ""
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        belongsTodo = try values.decode(String.self, forKey: .belongsTodo)
        belongsTodoSub = try values.decode(String.self, forKey: .belongsTodoSub)
        startTime = try values.decode(Date.self, forKey: .startTime)
        endTime = try values.decode(Date.self, forKey: .endTime)
        value = try values.decode(Int.self, forKey: .value)
        recordTime = try values.decode(Date.self, forKey: .recordTime)
        source = try values.decode(String.self, forKey: .source)
        note = try values.decode(String.self, forKey: .note)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(belongsTodo, forKey: .belongsTodo)
        try container.encode(belongsTodoSub, forKey: .belongsTodoSub)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(value, forKey: .value)
        try container.encode(recordTime, forKey: .recordTime)
        try container.encode(source, forKey: .source)
        try container.encode(note, forKey: .note)
    }
    
    static let empty = Record(belongsTodo: "", belongsTodoSub: "",  startTime: Date(), endTime: Date(), value: 1)
    
    static func ==(lhs: Record, rhs: Record) -> Bool{
        return lhs.id == rhs.id
    }
    
}
