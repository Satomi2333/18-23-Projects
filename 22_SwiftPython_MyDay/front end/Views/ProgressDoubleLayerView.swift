import SwiftUI

struct ProgressDoubleLayerView: View {
    var maxValue : Int
    var biggerValue : Int
    var smallerValue : Int
    var color : MyColor
    @State var shadowAnimation = 1.0
    
    var body: some View {
        ZStack{
            // 下层 长一点 多出来的部分表示今日完成
            ProgressView(value: Float(biggerValue), total: Float(maxValue))
                .progressViewStyle(.linear)
                .accentColor(color.toBrighterColor())
            //.shadow(color: .random(), radius: -3, x: 0, y: 0)
            
            // 上层 短一点 用原色表示
            ProgressView(value: Float(biggerValue-smallerValue), total: Float(maxValue))
                .progressViewStyle(.linear)
                .accentColor(color.toColor())
                .shadow(color: color.toColor(), radius: shadowAnimation, x: 0, y: 0)
                .onAppear(perform: {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(), {
                        shadowAnimation *= 3
                    })
                })
        }
    }
}

struct ProgressDoubleLayerView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressDoubleLayerView(maxValue: 100, biggerValue: 7, smallerValue: 0, color: .random())
    }
}
