import SwiftUI

struct FakeStringEditor: View {
    @Binding var real: String
    @Binding var show: String
    var title: String
    @State private var showReal = false
    @State var placeReal: String = ""
    @State var placeShow: String = ""
    var editContent: Bool = false //传入模版时为false 编辑已有内容时为true
    
    var body: some View {
        HStack {
            Button{
                showReal.toggle()
            } label: {
                Text(showReal ? "B面" : title)
//                    .font(.system(.body, design: .))
                    .animation(.interactiveSpring())
            }
            .buttonStyle(.plain)
            .frame(width: 40, alignment: .center)
            
            Divider()
            TextField(showReal ? placeReal : placeShow , text: showReal ? $real : $show)
//            TextEditor(text: showReal ? $real : $show)
//                .onChange(of: real, perform: { _ in
//                    print("changed!")
//                })
                .lineLimit(2)
                .padding(.leading, 3)
                .onSubmit(){
                    if showReal && real == "" {
                        real = placeReal
                    } else if !showReal && show == "" {
                        show = placeShow
                    }
                }
        }
        .padding(0)
        .onAppear(perform: {
            placeReal = real
            placeShow = show
            if !editContent {
                //当传入模版时将实际值清空，作为占位符显示
                real = ""
                show = ""
            } else {
                //当传入待编辑值时，将fakestring统一一下
                if show == real {
                    real = ""
                }
            }
        })
        .onDisappear(perform: {
            if show != real && real == "" {
                real = show
            }
        })
    }
}

//struct FakeStringEditor_Previews: PreviewProvider {
//    @State var s = "show"
//    @State var r = "real"
    
//    static var previews: some View {
//        FakeStringEditor(real: $r, show: $s)
//    }
//}
