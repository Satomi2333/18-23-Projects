import SwiftUI

struct MyDisclosureGroup<Content: View, Label: View>: View {
//    var title: String
//    var systemImage: String = ""
//    var color: Color = Color.random()
//    @Binding var showMore: Bool
    // TODO: 这个binding实在是搞不定了 在init里面又传不进去 不用init又用不了viewbuilder 所以就不传binding进来了 直接用state自嗨就完事儿
    @State private var showMore = true
    var content: Content
    var label: Label
    
    init(@ViewBuilder _ content: () -> Content, @ViewBuilder label: () -> Label){
//        self.showMore = showMore
        self.content = content()
        self.label = label()
    }
    
    var body: some View {
        VStack{
            HStack(alignment: .bottom, spacing: 10.0) {
                //            Label("today", image: "🐶")
                //            if systemImage != "" {
                //                Label("", systemImage: systemImage)
                //                    .foregroundColor(color)
                //            }
                //            Text(title)
                //                .font(.title2)
                //                .bold()
                //                .foregroundColor(colorScheme == .light ? .white : .dark)
                self.label
                Spacer()
                Button() {
                    showMore.toggle()
                } label: {
                    SwiftUI.Label("收起", systemImage: "chevron.forward")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.accentColor)
                        .rotationEffect(.degrees(showMore ? 90.0 : 0.0))
                }
                
            }
            .padding([.leading,.trailing,.top])
            .listSectionSeparator(.visible)
            //                    .redacted(reason: .privacy)
            
            if showMore {
                //                        ForEach(0..<10) { i in
//                ForEach(todos) {todo in
//                    //Divider()
//                    //.padding(.leading)
//                    TodoRow(todo: todo)
//                        .padding(.horizontal, 10)
//                    //.padding(.vertical,0)
//                        .background(.linearGradient(colors: [ ], startPoint: .top, endPoint: .bottom))
//                        .cornerRadius(10)
//                    
//                    //.buttonStyle(PlainButtonStyle())
//                }
                self.content
            } else {
                Divider()
                    .padding([.leading,.trailing])
            }
        }
    }
}

//struct MyDisclosureGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        MyDisclosureGroup()
//    }
//}
