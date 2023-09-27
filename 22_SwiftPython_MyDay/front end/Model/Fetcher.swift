import SwiftUI
import SwiftDate

//public class SyncData {
//    let fetcher = Fetcher()
//    
//    static func todo() async {
//        
//    }
//}

class PostBody: Encodable {
    var userId = "qwer"
    static func toData(me: PostBody) -> Data{
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
//        do {
            let encoded = (try? encoder.encode(me))!
//print("Body："+String(data: encoded, encoding: .utf8)!)
//        } catch {
//            print(error)
//        }
        
        return encoded
//        return "".data(using: .utf8)!
    }
}

class TodoBody: PostBody {
    var uploadTime: Date
    var source: String
    var content: [Todo]
    
    enum codingKeys: String, CodingKey {
        case uploadTime,source,content
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(uploadTime, forKey: .uploadTime)
        try container.encode(source, forKey: .source)
        try container.encode(content, forKey: .content)
    }
    
    init(upTime: Date, s: String, c: [Todo]){
        uploadTime = upTime
        source = s
        content = c
    }
}

class IdBody: PostBody {
    var id: String
    init(id: String){self.id = id}
    enum codingKeys: String, CodingKey {
        case id
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(id, forKey: .id)
    }
}

class IdsBody: PostBody {
    var ids: [String]
    init(ids: [String]) {self.ids = ids}
    
    enum codingKeys: String, CodingKey {
        case ids
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(ids, forKey: .ids)
    }
}

class RecordDayBody: PostBody {
    var start: DateInRegion
    var end: DateInRegion
    enum codingKeys: String, CodingKey {
        case start,end
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(start.date, forKey: .start)
        try container.encode(end.date, forKey: .end)
    }
    init(start s: DateInRegion, end e: DateInRegion){
        start = s
        end = e
    }
}

class ReturnedJson: Codable {
    var success: Int
    var description: String
//    enum CodingKeys: String, CodingKey {case success,description}
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        //        contents = try container.decode([String:Record].self, forKey: .contents)
//        success = try container.decode(Int.self, forKey: .success)
//        description = try container.decode(String.self, forKey: .description)
//    }
}

class ReturnedTodo: ReturnedJson{
    var contents: [Todo]
    enum CodingKeys: String, CodingKey {case contents, success, description}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contents = try container.decode([Todo].self, forKey: .contents)
        //        super.success = try container.decode(Int.self, forKey: .success)
        //        super.description = try container.decode(String.self, forKey: .description)
        try super.init(from: decoder)
    }
}

class ReturnedRecord: ReturnedJson {
    var contents: [String:Record]
    enum CodingKeys: String, CodingKey {case contents, success, description}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contents = try container.decode([String:Record].self, forKey: .contents)
        //        super.success = try container.decode(Int.self, forKey: .success)
        //        super.description = try container.decode(String.self, forKey: .description)
        try super.init(from: decoder)
    }
}

class ReturnedTodoRecord: ReturnedJson {
    var contents: [String:[Record]]
    enum CodingKeys: String, CodingKey {case contents, success, description}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contents = try container.decode([String:[Record]].self, forKey: .contents)
        //        super.success = try container.decode(Int.self, forKey: .success)
        //        super.description = try container.decode(String.self, forKey: .description)
        try super.init(from: decoder)
    }
}

class ReturnedSingleRecord: ReturnedJson {
    var content: Record
    enum CodingKeys: String, CodingKey {case success,description,content}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(Record.self, forKey: .content)
        //        super.success = try container.decode(Int.self, forKey: .success)
        //        super.description = try container.decode(String.self, forKey: .description)
        try super.init(from: decoder)
    }
}

class ReturnedStringArray: ReturnedJson {
    var contents: [String]
    enum CodingKeys: String, CodingKey {case contents, success, description}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contents = try container.decode([String].self, forKey: .contents)
        //        super.success = try container.decode(Int.self, forKey: .success)
        //        super.description = try container.decode(String.self, forKey: .description)
        try super.init(from: decoder)
    }
}

class Fetcher: ObservableObject {
    // SyncView: startSync, uploadAnyWay, getFromDB
    // GetAllRecords: deleteRecordFromCloud
    // CanvasView: getAllRecordFromSpecifyDay
    var serverUrl = "http://175.178.192.5/"
//    var serverUrl = "http://192.168.3.9:5000/"
//    var serverUrl = "http://113.55.38.79:5000/"

//    init(serverUrl: String){
//        self.serverUrl = serverUrl
//    }
    
    enum RequestMethod: String {
        case GET, POST
    }
    
    class Actions {
        var method: RequestMethod
        var url: String
        var body: Data?
        
        init(url: String){
            self.url = url
            self.method = .GET
        }
        
        init(url: String, method: RequestMethod, body: Data?){
            self.url = url
            self.method = method
            self.body = body
        }
        
        func addVar(_ v: String) {
            self.url += "/"+v.replacingOccurrences(of: " ", with: "%20")
        }
        
        func addParam(_ d: Dictionary<String,String>){
            self.url += "?"
            for (k,v) in d {
                self.url += "\(k)=\(v)"
            }
        }
        
        //        static let syncTodo = Actions(url: "record/add", method: "post", body: "".data(using: .utf8))
        static let getAllRecord = Actions(url: "record/all")
        static var getOneRecord = Actions(url: "record/single")
        static var deleteOneRecord = Actions(url: "record/delete")
        static let getNewestTodo = Actions(url: "todo/newest")
        static var getAllTodo = Actions(url: "todo/all")
        static let getAllHalfRecord = Actions(url: "halfRecord/all")
        static let getAllSourceDistinct = Actions(url: "record/source/distinct")
        static let getAllAppDistinct = Actions(url: "record/app/distinct")
        static let getAllToDeleteRecord = Actions(url: "record/todelete/all")
    }
    
    func httpRequest(actions: Actions, doNext: (_ data: Data) async ->()) async 
    throws 
    {
        //        print("start fetch")
        guard let url = URL(string: serverUrl+actions.url) else {print("invalid url");return}
        print("URL: "+url.relativeString)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = actions.method.rawValue
        if actions.method == .POST {
            urlRequest.httpBody = actions.body!
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        //print(response)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { print("noResponse");return }
        //        print(String(data: data, encoding: .utf8)!)
        await doNext(data)
    }
}
