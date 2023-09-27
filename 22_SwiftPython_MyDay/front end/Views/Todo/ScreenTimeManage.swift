//
//  ScreenTimeManage.swift
//  
//
//  Created by ミズちゃん on 2022/3/24.
//

import SwiftUI

struct ScreenTimeManageView: View {
//    @EnvironmentObject userSetting: UserSetting
    @EnvironmentObject var todoModel : TodoModel
    @State var color1 = Color.random().opacity(0.2)
    @State var color2 = Color.random().opacity(0.2)
    @State var sources : [String] = []
    @State var apps : [String] = []
    
    var body: some View {
//        NavigationView {
        List {
            Section{
                SourceRowView(isThisDevice: false, color: $color1)
                SourceRowView(isThisDevice: true, color: $color2)
                ForEach(sources, id:\.self){ source in 
                    Text(source)
                }
            } header: {
                Text("source")
            }
            
            
            Section {
                AppAndTodo(color: $color2)
                ForEach(apps, id:\.self){ app in 
                    Text(app)
                }
            } header: {
                Text("App")
            }
        }//list
        .onAppear{
            getAllSource()
            getAllApp()
        }
//        }//navigation
    }
    
    func getAllSource(){
        var unique = Set<String>()
        for record in todoModel.records {
            unique.insert(record.source)
        }
        sources = Array<String>(unique)
    }
    
    func getAllApp(){
        var unique = Set<String>()
        for record in todoModel.records {
            if record.belongsTodo == "screenTime" {
                unique.insert(record.belongsTodoSub)
            }
        }
        apps = Array<String>(unique)
    }
}

struct AppAndTodo: View {
    @Binding var color : Color
    
    var body: some View {
        DisclosureGroup{
            HStack {
                Picker("todo", selection:.constant(1)){
                    Text("1")
                    Text("2")
                }
                .frame(maxWidth:40, maxHeight: 100)
                .pickerStyle(.wheel)
                
                Picker("todo", selection:.constant(1)){
                    Text("1")
                    Text("2")
                }
                .frame(maxHeight: 20)
                .pickerStyle(.wheel)
                
            }
        } label: {
            SourceRowView(isThisDevice: false, color: $color)
        }
    }
}

struct SourceRowView: View {
    var isThisDevice: Bool = false
    @Binding var color: Color
    @State var text = "ミズのケータイ"
    
    var body: some View {
        HStack {
            Text("\(isThisDevice ? "(This)" : "")")
                .foregroundColor(.gray.opacity(0.5))
                .font(.headline)
//                .padding(.leading,5)
            TextField(text:$text){}
                .foregroundColor(.gray.opacity(0.5))
                .font(.headline)
            Spacer()
            ColorPicker(selection: $color){}
            .frame(maxWidth:50)
            
        }
//        .background(content: {color})
        .background(content: {
            Capsule(style: .continuous)
                .foregroundColor(color)
        })
        
    }
}

//struct ScreenTimeManageView_Previews: PreviewProvider {
    //static var previews: some View {
        //ScreenTimeManageView()
        //}
//}
