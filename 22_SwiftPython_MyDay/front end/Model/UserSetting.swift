import SwiftUI

class UserSetting: ObservableObject, Codable {
    @Published var showReal: Bool
    @Published var showRecordsOnlyNotNil: Bool
    @Published var deviceName: String
    @Published var serverUrl = "http://192.168.1.1:5001/"
    @Published var todayMore = false
    @Published var showShortTodoRow = false
    @Published var notification = "一个醒目的提醒"
    var toDeleteRecord: [String] = []
    @Published var sortTodoSubsByRecent = false
    
    enum CodingKeys: String, CodingKey {
        case showReal, showRecordsOnlyNotNil, deviceName, serverUrl, todayMore, showShortTodoRow, toDeleteRecord, notification, sortTodoSubsByRecent
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        showReal = try container.decode(Bool.self, forKey: .showReal)
        showRecordsOnlyNotNil = try container.decode(Bool.self, forKey: .showRecordsOnlyNotNil)
        deviceName = try container.decode(String.self, forKey: .deviceName)
        serverUrl = try container.decode(String.self, forKey: .serverUrl)
        todayMore = try container.decode(Bool.self, forKey: .todayMore)
        showShortTodoRow = try container.decode(Bool.self, forKey: .showShortTodoRow)
        toDeleteRecord = try container.decode([String].self, forKey: .toDeleteRecord)
        notification = try container.decode(String.self, forKey: .notification)
        sortTodoSubsByRecent = try container.decode(Bool.self, forKey: .sortTodoSubsByRecent)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(showReal, forKey: .showReal)
        try container.encode(showRecordsOnlyNotNil, forKey: .showRecordsOnlyNotNil)
        try container.encode(deviceName, forKey: .deviceName)
        try container.encode(serverUrl, forKey: .serverUrl)
        try container.encode(showShortTodoRow, forKey: .showShortTodoRow)
        try container.encode(todayMore, forKey: .todayMore)
        try container.encode(toDeleteRecord, forKey: .toDeleteRecord)
        try container.encode(notification, forKey: .notification)
        try container.encode(sortTodoSubsByRecent, forKey: .sortTodoSubsByRecent)
    }
    
    init(show: Bool){
        if let settingFromUD =  UserDefaults.standard.data(forKey: "userSetting") {
            do {
                let settings = try JSONDecoder().decode(UserSetting.self, from: settingFromUD)
                serverUrl = settings.serverUrl
                showReal = settings.showReal
                showRecordsOnlyNotNil = settings.showRecordsOnlyNotNil
                deviceName = settings.deviceName
                todayMore = settings.todayMore
                showShortTodoRow = settings.showShortTodoRow
                toDeleteRecord = settings.toDeleteRecord
                notification = settings.notification
                sortTodoSubsByRecent = settings.sortTodoSubsByRecent
            } catch {
                showReal = show
                showRecordsOnlyNotNil = true
                deviceName = UIDevice.current.name
                serverUrl = "http://192.168.1.1:5001/"
                todayMore = true
                showShortTodoRow = false
                toDeleteRecord = []
                notification = "一个醒目的提醒"
                sortTodoSubsByRecent = false
            }
        } else {
            showReal = show
            showRecordsOnlyNotNil = true
            deviceName = UIDevice.current.name
            serverUrl = "http://192.168.1.1:5001/"
            todayMore = true
            showShortTodoRow = false
            toDeleteRecord = []
            notification = "一个醒目的提醒"
            sortTodoSubsByRecent = false
        }
    }
    
    func save(me: UserSetting){
        let toSave = try? JSONEncoder().encode(me)
        UserDefaults.standard.set(toSave, forKey: "userSetting")
    }
    
    
    
    
}
