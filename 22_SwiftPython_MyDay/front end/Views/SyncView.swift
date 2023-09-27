import SwiftUI

struct SyncView: View {
    @EnvironmentObject var userSetting: UserSetting
    @EnvironmentObject var todoModel: TodoModel
    @Environment(\.presentationMode) var presentationMode
    @State var log: String = ""
    @State var progressNow = 2.0
    @State var doing = false
    @State var showWhatTodo = false
    
    var body: some View {
        VStack {
            TextField("serverUrl", text: $userSetting.serverUrl)
                .textFieldStyle(.roundedBorder)
//            ScrollView(.vertical, showsIndicators: false) {
                TextEditor(text: $log)
                    .lineLimit(8)
                    .disabled(true)
//            }
            ProgressView(value: progressNow, total: 6.0)
                .progressViewStyle(.linear)
            HStack {
                Button("retry"){
                    Task { try await startSync() }
                }
                .disabled(doing)
                Button("ok"){
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
//        .frame(maxHeight: 300)
        .onAppear(perform: {
            Task(operation: {
                try await startSync()
            })
        })
        .alert(isPresented: $showWhatTodo) {
            Alert(title: Text("What to do next?"), 
                  message: Text("Find newer todos in db, continue upload?"), 
                  primaryButton: .default(Text("Get from db"), action: {Task {await getFromDB()}}), 
                  secondaryButton: .destructive(Text("Upload anyway"), action: {Task{await uploadAnyWay()}}))
        }
    }
    
    func getFromDB() async {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let fetcher = Fetcher()
        fetcher.serverUrl = userSetting.serverUrl
        try? await fetcher.httpRequest(actions: .getNewestTodo, doNext: { data in
            let returnedTodo = (try? decoder.decode(ReturnedTodo.self, from: data))!
            if returnedTodo.success == 1 {
                print("getNewestFromDB")
                todoModel.todos = returnedTodo.contents
                todoModel.initDicts()
                return
            } else {
                return
            }
        })
    }
    
    func uploadAnyWay() async {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let fetcher = Fetcher()
        fetcher.serverUrl = userSetting.serverUrl
        let todoBody : Data = TodoBody.toData(me: TodoBody(upTime: Date(), s: userSetting.deviceName, c: todoModel.todos))
        let action = Fetcher.Actions(url: "todo/justUp", method: .POST, body: todoBody)
        try? await fetcher.httpRequest(actions: action, doNext: { data in
            let returnedTodo = (try? decoder.decode(ReturnedTodo.self, from: data))!
            if returnedTodo.success == 2 {
                print("uploadAnywaysub")
                return
            } else {
                return
            }
        })
//        return 1
    }
    
    func startSync() async throws {
        doing = true
        log = ""
        progressNow = 0.0
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let fetcher = Fetcher()
        fetcher.serverUrl = userSetting.serverUrl
        log += "Start sync todos...\n"
        progressNow += 1.0
        let todoBody : Data = TodoBody.toData(me: TodoBody(upTime: Date(), s: userSetting.deviceName, c: todoModel.todos))
//        let action1 = Fetcher.Actions(url: "todo/push", method: .POST, body: """
//{"uploadTime":"\(Date().ISO8601Format())","source":"\(userSetting.deviceName)","content":"\(todoModel.export(for: .Todos, toDB: true))"}
//""".data(using: .utf8)!)
        
//        let action1 = Fetcher.Actions(url: "todo/push", method: .POST, body: """
//{"uploadTime":"\(Date().ISO8601Format())","source":"\(userSetting.deviceName)","content":"\("[{\"1\":\"12\"},{}]".data(using: .utf8)!)"}
//""".data(using: .utf8)!)
        
//        let action1 = Fetcher.Actions(url: "todo/push", method: .POST, body: todoModel.exportAsData(for: .Todos))
        let action1 = Fetcher.Actions(url: "todo/push", method: .POST, body: todoBody)
        try? await fetcher.httpRequest(actions: action1, doNext: { data in 
//            print(String(data: data, encoding: .utf8)!)
            let returnedTodo = (try? decoder.decode(ReturnedTodo.self, from: data))!
            log += returnedTodo.description + "\n"
            if returnedTodo.success < 0 {
                doing = false
                log += "Something wrong."
                return
            }
            if returnedTodo.success == 10 {
                log += returnedTodo.description + "\n"
                showWhatTodo = true
            }
            progressNow += 1.0
            if returnedTodo.success == 1 {
//                print(returnedTodo.contents)
                todoModel.todos = returnedTodo.contents
                log += "Local todos has been updated.\n"
            }
            
        })
        
        let deleteRecord = Fetcher.Actions(url: "record/todelete/adds", method: .POST, body: TodoBody.toData(me: IdsBody(ids: userSetting.toDeleteRecord)))
        try? await fetcher.httpRequest(actions: deleteRecord, doNext: { data in
            let returned = (try? decoder.decode(ReturnedJson.self, from: data))!
            if returned.success == 1 {
                log += returned.description+"\n"
                userSetting.toDeleteRecord = []
            } else if returned.success == 2 {
                log += returned.description+"\n"
            } else {
                log += returned.description+"\n"
                return
            }
        })
        
        try? await fetcher.httpRequest(actions: .getAllToDeleteRecord, doNext: { data in 
            let returned = (try? decoder.decode(ReturnedStringArray.self, from: data))!
            log += "deleting local records"
            if returned.success == 1 {
                for rid in returned.contents {
                    todoModel.records.removeAll(where: {$0.id == rid})
                    log += "."
                }
            }
            log += "\n"
        })
        
        try? await fetcher.httpRequest(actions: .getAllRecord, doNext: {data in
            let returnedRecord = (try? decoder.decode(ReturnedRecord.self, from: data))!
            if returnedRecord.success == 1 {
                log += returnedRecord.description+"\n"
                progressNow += 1.0
            }
            var tempLocalToSave : [Record] = []
            var tempCloudToSave : [Record] = []
            var local = Set<String>()
            var cloud = Set<String>()
            var localRecordDict : [String:Record] = [:]
            let cloudRecordDict = returnedRecord.contents
            for record in todoModel.records {
                local.insert(record.id)
                localRecordDict[record.id] = record
            }
            for (rid, _) in cloudRecordDict {
                cloud.insert(rid)
            }
            for toAdd in cloud.subtracting(local) {
                // 做cloud-local即为需要保存至本地的
                tempLocalToSave.append(cloudRecordDict[toAdd]!)
            }
            
            todoModel.records += tempLocalToSave
            log += "\(tempLocalToSave.count) records from cloud has been saved to local.\n"
            progressNow += 1.0
            
            for toAdd in local.subtracting(cloud) {
                // 做local-cloud即为需要上传的
                tempCloudToSave.append(localRecordDict[toAdd]!)
            }
//            print(cloud)
//            print(local)
//            return 1
            
            log += "\(tempCloudToSave.count) records from local are updating to cloud."
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
//            let fetcher = Fetcher()
//            fetcher.serverUrl = userSetting.serverUrl
            for toUpload in tempCloudToSave {
                let body = (try? encoder.encode(toUpload))!
                let action2 = Fetcher.Actions(url: "record/add", method: .POST, body: body)
                try? await fetcher.httpRequest(actions: action2, doNext: {data in 
                    let returned = (try? decoder.decode(ReturnedJson.self, from: data))!
                    switch returned.success {
                    case 1:
                        log += "."
                        progressNow += 1.0/Double(tempCloudToSave.count)
                    case -1,-2:
                        log += "\n\(returned.description)"
                        doing = false
                        return
                    default:
                        log += "\n???"
                        doing = false
                        return
                    }
                })
            }
            log += "\nInit Datas"
            todoModel.initDicts()
            progressNow += 1.0
            
            log += "\nDone!"
            progressNow += 1.0
            doing = false
        })
    }
}

struct SyncView_Previews: PreviewProvider {
    static var previews: some View {
        SyncView()
            .environmentObject(UserSetting(show: true))
            .environmentObject(TodoModel())
    }
}
