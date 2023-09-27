import SwiftUI

struct TomatoView: View {
//    let timer = Timer(timeInterval: 1, target: <#T##Any#>, selector: <#T##Selector#>, repeats: true)
    
    var body: some View {
        VStack {
                Canvas { context, size in
                    var line = Path()
                    line.addArc(center: CGPoint(x: size.width/2, y: size.height/2), radius: size.width/2-25, startAngle: .degrees(89), endAngle: .degrees(90), clockwise: true)
                    
                    context.stroke(line, with: .color(.accentColor.opacity(0.8)), style: StrokeStyle(lineWidth: 50))
                }
                .frame(width: 300, height: 300, alignment: .center)
            
        }
    }
}

struct TomatoView_Previews: PreviewProvider {
    static var previews: some View {
        TomatoView()
    }
}
