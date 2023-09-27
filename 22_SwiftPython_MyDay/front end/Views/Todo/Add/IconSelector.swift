import SwiftUI

struct IconSelector: View {
    @Binding var iconChoosed: String
    @Binding var showIconSelector: Bool
    @Environment(\.presentationMode) var presentationMode
    var color: CGColor
    static let icons: [String] = ["calendar",
                                  "book",
                                  "book.closed",
                                  "graduationcap",
                                  "globe",
                                  "network",
                                  "sun.min",
                                  "sun.max",
                                  "moon",
                                  "keyboard",
                                  "seal",
                                  "drop",
                                  "play",
                                  "pause",
                                  "stop",
                                  "circle",
                                  "capsule",
                                  "capsule.portrait",
                                  "oval",
                                  "oval.portrait",
                                  "square",
                                  "app",
                                  "rectangle",
                                  "rectangle.portrait",
                                  "triangle",
                                  "diamond",
                                  "octagon",
                                  "hexagon",
                                  "pentagon",
                                  "heart",
                                  "rhombus",
                                  "flag",
                                  "bolt",
                                  "eye",
                                  "tshirt",
                                  "mouth",
                                  "facemask",
                                  "brain",
                                  "camera",
                                  "phone",
                                  "envelope",
                                  "bag",
                                  "cart",
                                  "creditcard",
                                  "pianokeys",
                                  "hammer",
                                  "puzzlepiece.extension",
                                  "house",
                                  "building",
                                  "wifi",
                                  "display",
                                  "laptopcomputer",
                                  "headphones",
                                  "airplane",
                                  "car",
                                  "bus",
                                  "tram",
                                  "bicycle",
                                  "scooter",
                                  "bed.double",
                                  "cross",
                                  "pawprint",
                                  "leaf",
                                  "film",
                                  "face.smiling",
                                  "crown",
                                  "shield",
                                  "cube",
                                  "clock",
                                  "alarm",
                                  "chart.xyaxis.line",
                                  "gamecontroller",
                                  "rectangle.roundedtop",
                                  "rectangle.roundedbottom",
                                  "logo.playstation",
                                  "logo.xbox",
                                  "cup.and.saucer",
                                  "takeoutbag.and.cup.and.straw",
                                  "fork.knife",
                                  "figure.walk",
                                  "hand.thumbsup",
                                  "hands.clap",
                                  "waveform.path.ecg",
                                  "gift",
                                  "studentdesk",
                                  "lightbulb",
                                  "1.circle",
                                  "2.circle",
                                  "3.circle",
                                  "4.circle",
                                  "5.circle",
                                  "doc",
                                  "folder",
                                  "pencil",
                                  "trash",]
    
    var body: some View {
//        GridItem()
        VStack{
            HStack{
                Button("溜了"){
                    showIconSelector = false
                }
                .padding([.top, .leading])
                Spacer()
                Text("选择一个图标")
                //                .font(.title3)
                    .padding(.top)
                    
                Spacer()
                Button("随机"){
                    iconChoosed = IconSelector.icons.randomElement()!
                    showIconSelector = false
                }
                    .padding([.top, .trailing])
            }
            
            Group{
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 100))]) {
                        ForEach(IconSelector.icons, id:\.hash ){ icon in
                            Button{
                                iconChoosed = icon
                                showIconSelector = false
                            } label: {
                                Image(systemName: icon)
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 40.0))
//                                    .resizable()
                            
//                                    .scaledToFit()
//                                    .colorMultiply(color)
                                    .foregroundColor(MyColor(cgcolor: color).toColor())
//                                    .tint(color)
                                    
                                    
                            }
                        }
                    }
                }
                .padding()
                .background(.bar)
            }
            
            HStack {
                TextField("system name", text: $iconChoosed)
                    .padding([.horizontal,.bottom])
                    .textCase(.lowercase)
                    .onSubmit {
                        iconChoosed = iconChoosed.lowercased()
                        showIconSelector = false
                    }
            }
        }
    }
}

//struct IconSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        IconSelector()
//    }
//}
