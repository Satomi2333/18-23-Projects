import SwiftUI

struct ImportView: View {
    @State var toSaveRecord: String = ""
    @State var toSaveTodo: String = ""
    @Environment(\.presentationMode) var showing
    @State var toSave : SaveTarget = .todos
    @EnvironmentObject var todoModel: TodoModel
    
    enum SaveTarget {
        case todos
        case records
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("取消", role: .cancel){
                    showing.wrappedValue.dismiss()
                }
                .buttonStyle(.automatic)
                .frame(width:80)
                
                Spacer()
                
                Label("Import", systemImage: "square.and.arrow.down")
                    .symbolRenderingMode(.hierarchical)
                
                Spacer()
                
                Button("导入"){
                    switch toSave {
                    case .records:
                        let success = todoModel.importFromJSON(jsonString: toSaveRecord, toSave: .Records)
                        print(success ? "导入成功，可以退出去看一眼，建议两个都导入以后重启一下程序" : "导入失败")
                    case .todos:
                        let success = todoModel.importFromJSON(jsonString: toSaveTodo, toSave: .Todos)
                        print(success ? "导入成功，可以退出去看一眼，建议两个都导入以后重启一下程序" : "导入失败")
                    }
                    todoModel.saveAll()
                }
                .buttonStyle(.automatic)
                .frame(width:80)
                
            }
            
            Picker(selection: $toSave){
                Text("todo").tag(SaveTarget.todos)
                Text("record").tag(SaveTarget.records)
            } label: { Text("text") }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            TextEditor(text: toSave == .todos ? $toSaveTodo : $toSaveRecord)
//                .lineLimit(10)
                .shadow(radius: 1)
//                .frame(height:200)
                .padding([.horizontal,.bottom])
            
            Text("Tips: 同账号的多设备支持云粘贴哦～")
            
            Text("保存至: ")+Text(toSave == SaveTarget.records ? "Record" : "Todo")
            
        }
        .padding(.vertical,15)
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView(toSaveRecord: "", toSaveTodo: "")
    }
}
