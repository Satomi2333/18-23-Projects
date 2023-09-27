import SwiftUI

struct FakeIconEditor: View {
    @Binding var real: String
    @Binding var show: String
    @Binding var color: MyColor
    @State var colorTemp : CGColor = .random()
    var title: String
    @State private var showReal = false
    @State var showIconSelector = false
//    @Environment(\.presentationMode) var presentationMode
    
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
            
            Button {
                showIconSelector.toggle()
            } label: {
                Image(systemName: showReal ? real : show)
                    .symbolRenderingMode(.hierarchical)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(color.toColor())
                    .frame(width: 30, height: 30)
                    .padding(.horizontal, 5)
                    
            }
            .buttonStyle(.plain)
            .background{ Color.white }
            
            Button {
                showIconSelector.toggle()
            } label: {
                Image(systemName: showReal ? real : show)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(color.toColor())
                    .frame(width: 30, height: 30)
                    .padding(.horizontal, 5)
            }
            .buttonStyle(.plain)
            .background{ Color.dark }
            
            Spacer()
            
            ColorPicker(selection: $colorTemp){
//                let c = Color.random()
            }
            .onChange(of: colorTemp, perform: { newColor in
                color = MyColor(cgcolor: newColor)
            })
            
        }
        .padding(0)
        .sheet(isPresented: $showIconSelector, content: {IconSelector(iconChoosed: showReal ? $real : $show, showIconSelector: $showIconSelector, color: colorTemp)})
        .onAppear(perform: {
            colorTemp = color.toCGColor()
        })
    }
}

//struct FakeIconEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        FakeIconEditor()
//    }
//}
