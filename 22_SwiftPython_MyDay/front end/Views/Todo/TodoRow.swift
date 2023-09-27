import SwiftUI

struct TodoRow: View {
    @EnvironmentObject var userSetting: UserSetting
    @State var showDetail: Bool = false
    @StateObject var todo: Todo
    @State var selection = 0
    @State var showAddRecordView = false
    @State var pageNow = 0
    var onlyForShow: Bool
    var maxShow = 4
    var needScroll : Bool {
        return (todo.todoSub.count > maxShow)
    }
    var pageLeft : Int {
        return maxShow * pageNow
    }
    var pageRight : Int {
        return min(todo.todoSub.count, maxShow * (pageNow+1))
    }
    var canLeft : Bool {
        return (pageNow != 0) && needScroll
    }
    var canRight : Bool {
        return ((pageNow+1) * maxShow < todo.todoSub.count)
    }
    var subNow: TodoSub {
        //todo.todoSub[selection + pageNow * maxShow]
        sortedTodoSubs[selection]
    }
    
    var subNowSta : Statistics {
        return subNow.statistics
    }
    
    var sortedTodoSubs : [TodoSub] {
        if userSetting.sortTodoSubsByRecent {
            return todo.todoSubSorted
        } else {
            return todo.todoSub
        }
    }
    
    var body: some View {
//        GeometryReader { geometry in
//            Text("\(geometry.size.width)") //300
//        }
        if userSetting.showShortTodoRow {
            HStack(spacing:0) {
//                Label(todo.name.value(userSetting.showReal), systemImage: todo.icon.value(userSetting.showReal))
//                    .foregroundColor(todo.iconColor.toColor())
//                    .frame(width: 100, alignment: .leading)
//                    .font(.bold(.body)())
                //这个图标对不齐 还是用下面这个比较好看
                
                NavigationLink {
                    if !onlyForShow {
                        TodoDetail(todo: todo)
                    }
                } label: {
                    Image(systemName: todo.icon.value(userSetting.showReal))
                        .foregroundColor(todo.iconColor.toColor())
                        .frame(maxWidth:20)
                    Text(todo.name.value(userSetting.showReal))
                        .foregroundColor(todo.iconColor.toColor())
                        .frame(maxWidth:70, alignment: .leading)
                        .lineLimit(1)
                }
                
                Divider()
                    .padding(.leading,8)
                
                HStack(spacing: 0) {
                    if needScroll {
                        Button{
                            pageNow -= 1
                            selection = pageLeft
                        } label: {
                            Image(systemName: canLeft ? "triangle.fill" : "triangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 13,height: 13)
                                .foregroundColor(todo.iconColor.toColor())
                                .rotationEffect(.degrees(-90))
                                .padding(.horizontal, 3)
                            
                        }
                        .disabled(!canLeft)
                    }
                    
                    
                    ZStack {
                        Picker("", selection: $selection){
                            //                    ForEach(0..<todo.todoSub.count) { index in
                            //                        let sub = todo.todoSub[index]
                            //                        Text(sub.name.value(userSetting.showReal)).tag(index)
                            //                    }
                            ForEach(sortedTodoSubs[pageLeft..<pageRight]) { sub in
                                Text(sub.name.value(userSetting.showReal)).tag(sortedTodoSubs.firstIndex(where: { $0.id == sub.id })!)
                                
                            }
                            
                        }
                        .pickerStyle(.segmented)
                        .zIndex(1)
                        
                        if !subNow.statistics.endless {
                            ProgressDoubleLayerView(maxValue: todo.todoSub[selection].statistics.endValue, biggerValue: subNow.statistics.tempValueTotal, smallerValue: subNowSta.tempValueToday, color: todo.iconColor)
                                .offset(x: 0, y: 13)
                                .zIndex(2)
                        }
                    }
                    .padding(.horizontal, needScroll ? 0 : 8)
                    
                    if needScroll {
                        Button {
                            pageNow += 1
                            selection = pageLeft
                        } label: {
                            Image(systemName: canRight ? "triangle.fill" : "triangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 13,height: 13)
                                .foregroundColor(todo.iconColor.toColor())
                                .rotationEffect(.degrees(90))
                                .padding(.horizontal, 3)
                        }
                        .disabled(!canRight)
                    }
                }
                
//                VStack {
//                    ForEach(todo.todoSub) { sub in
//                        Text(sub.name.value(userSetting.showReal))
//                            .font(.subheadline)
//                    }
//                }
                .sheet(isPresented: $showAddRecordView, onDismiss: {
                    showAddRecordView = false
                }, content: {
                    AddRecordView(todo: todo, subSelection: selection, showSelf: $showAddRecordView)
                })
                Divider()
                    .padding(.trailing,8)
                
                Button{
                    if !onlyForShow {
                        showAddRecordView = true
                    }
                } label: {
                    Text("打卡")
                }
                //.foregroundColor(todo.iconColor.toColor())
                .disabled(onlyForShow)
            }
            .foregroundColor(todo.iconColor.toColor())
        } else {
        VStack(spacing: 2) {
            HStack {
                Image(systemName: todo.icon.value(userSetting.showReal))
                    .symbolRenderingMode(.hierarchical)
                    .resizable()
                //.frame(minWidth: 10, idealWidth: 15, maxWidth: 30, minHeight: 10, idealHeight: 15, maxHeight: 30, alignment: .center)
                    .scaledToFit()
                .frame(minWidth: 15, idealWidth: 30, maxWidth: 30, minHeight: 15, maxHeight: 30, alignment: .center)
                .padding(.trailing,10)
                    .foregroundColor(todo.iconColor.toColor())
                
                NavigationLink {
                    if !onlyForShow {
                        TodoDetail(todo: todo)
                    }
                } label:{
                    VStack(alignment:.leading, spacing: 3) {
                        HStack{
                            Text(todo.name.value(userSetting.showReal)) //阅读
                                .bold()
                            
                            Text("已完成\(todo.finishedTimes)次")
                                .font(.caption2)
                            
                            todo.onlyShowTimes ? Text("") : Text("累计时长：\(Int.toHour(todo.spentTime) )").font(.caption2)
                            
//                            Text("index:\(selection)")
                        }
                        
                        Text(todo.detail.value(userSetting.showReal)) //详细描述
                            .font(.caption)
                            .truncationMode(.tail)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
                .disabled(onlyForShow)
//                .foregroundColor(.black)
                .buttonStyle(PlainButtonStyle())
                .navigationBarTitleDisplayMode(.large)
                
                Spacer()
                
                Button {
//                    if !onlyForShow {
                        showDetail.toggle()
//                    }
                } label: {
                    Image(systemName: "chevron.forward")
//                        .resizable()
//                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(.accentColor)
                        .padding(.leading,5)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        
                }
                .buttonStyle(.borderless)
            }
            .padding(.bottom, 0)
            
            HStack {
                Picker(selection: $selection, label:Text("选择一个子任务")) {
                    ForEach(sortedTodoSubs) { sub in
                        Text(sub.name.value(userSetting.showReal)).tag(sortedTodoSubs.firstIndex(where: { $0.id == sub.id })!)
                            .frame(width: 20)
//                        Text("\(index)")
                        //使用index的方法会在当条目被删除时产生越界错误
                        //而当前仍然存在越界错误 当选中的条目为最后一个而
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 0)
                .foregroundColor(.green)
//                .onChange(of: selection, perform: {
//                    todo.todoSubSelection
//                })
                
                VStack(alignment: .leading) {
                    //Text("\(subNow.name.value(userSetting.showReal))")
                    //.font(.caption2)
//                    Text("\(subNow.statistics.getDescription())")
//                        .font(.caption2)
//                    subNow.statistics.getDescriptionView()
                    ZStack(alignment: .leading) {
                        VStack(alignment:.trailing){
                            Text(subNow.statistics.getDescription(today: true, userSetting.showReal))
                            Text(subNow.statistics.getDescription(today: false, userSetting.showReal))
                        }
                        .font(.caption2)
                        
                        if !subNow.statistics.endless {
                            ProgressDoubleLayerView(maxValue: todo.todoSub[selection].statistics.endValue, biggerValue: subNow.statistics.tempValueTotal, smallerValue: subNow.statistics.tempValueToday, color: todo.iconColor)
                            //ZStack{
                            //// 下层 长一点 多出来的部分表示今日完成
                            //ProgressView(value: Float(subNow.statistics.tempValueTotal), total: Float(subNow.statistics.endValue))
                            //.progressViewStyle(.linear)
                            //.accentColor(todo.iconColor.toBrighterColor())
////                                    .shadow(color: .random(), radius: 3, x: 0, y: 0)
                            //// 上层 短一点 用原色表示
                            //ProgressView(value: Float(subNow.statistics.tempValueTotal-subNow.statistics.tempValueToday), total: Float(subNow.statistics.endValue))
                            //.progressViewStyle(.linear)
                            //.accentColor(todo.iconColor.toColor())
                            //}
                        }
                    }
                    
                }
                
                Spacer()
                
//                Button{
//                    
//                } label: {
//                    Label("计时打卡", systemImage: "timer")
//                        .font(.caption)
//                }
//                .buttonStyle(.bordered)
                
                Button {
                    if !onlyForShow {
                        showAddRecordView = true
                    }
                } label: {
                    Label("打卡", systemImage: "clock.badge.checkmark")
                        .font(.caption)
                }
                .disabled(onlyForShow)
                .buttonStyle(.bordered)
            }
            .padding(.vertical,0)
            
            if showDetail {
                VStack(alignment: .leading, spacing: 0){
                    Text("频率：\(todo.frequency.rawValue.capitalized)")
                        .font(.caption)
                        .padding(.vertical,0)
                    (Text("创建日期：") + Text(todo.creationDate,style: .date))
                        .font(.caption)
                        .padding(.vertical,0)
                    if todo.hasEnding {
                        (Text("截止日期：") + Text(todo.endDate, style: .relative))
                            .font(.caption)
                            .padding(.vertical,0)
                    }
                }
//                .padding(.horizontal,30)
//                .frame(width: 300)
                
            }//if-showDetail
            
        }//vstack
        .sheet(isPresented: $showAddRecordView, onDismiss: {
            showAddRecordView = false
        }, content: {
            AddRecordView(todo: todo, subSelection: selection, showSelf: $showAddRecordView)
        })
        .foregroundColor(todo.iconColor.toColor())
        }//if-showShort
        
    }
}

struct TodoRow_Previews: PreviewProvider {
    static var todo = Todo.test
    //@Binding private var selection = 0
    
    static var previews: some View {
        TodoRow(todo: todo, onlyForShow: true)
            .environmentObject(UserSetting(show: true))
    }
}
