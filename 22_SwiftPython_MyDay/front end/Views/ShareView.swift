import SwiftUI

struct ShareView: View {
    @State var toShareTodo: String
    @State var toShareRecord: String
//    @State var show: Bool
    @Environment(\.presentationMode) var showing
    @State var toSave : SaveTarget = .todos
    
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
                
                Label("Export", systemImage: "square.and.arrow.up")
                    .symbolRenderingMode(.hierarchical)
                    .onTapGesture {
                        switch toSave {
                        case .records: print(toShareRecord)
                        case .todos: print(toShareTodo)
                        }
                    }
                
                Spacer()
                
                Button("复制"){
                    switch toSave {
                        case .records:UIPasteboard.general.string = toShareRecord
                        case .todos:UIPasteboard.general.string = toShareTodo
                    }
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
            
            TextEditor(text: toSave == .todos ? $toShareTodo : $toShareRecord)
                .lineLimit(10)
                .shadow(radius: 1)
//                .frame(height:200)
                .padding([.horizontal,.bottom])
            
            Text("Tips: 同账号的多设备支持云粘贴哦～")
            
//            Text("保存至: ")+Text(toSave == SaveTarget.records ? "Record" : "Todo")
            
        }
        .padding(.vertical,15)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(toShareTodo: "testT",toShareRecord: "testR")
    }
}
