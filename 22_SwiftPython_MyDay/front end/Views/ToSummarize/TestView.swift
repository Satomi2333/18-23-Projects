import SwiftUI

struct TestView: View {
    @State var widthNow = 0.0
    @State var scale = 1.0
    
    var body: some View {
//        TimelineView(.periodic(from: Date(), by: 1)) { context in
//            Text("\(Date())")
//        }
        VStack {
            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    Text("\(geometry.size.width)")
                    Capsule()
                        .frame(width: geometry.size.width*scale, height: 30)
                }
            }
            
            ScrollView {
                Capsule()
                Circle()
                Ellipse()
                Rectangle()
                Color(red: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, green: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, blue: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/)
                Slider(value: $scale, in: 1.0...3.0)
                Canvas { context, size in
                    var line = Path()
                    line.move(to: CGPoint(x: 100, y: 100))
                    line.addLine(to: CGPoint(x: 100, y: size.height*2))
                    
                }
                Path() { path in
                    path.move(to: CGPoint(x: 200, y: 100))
                    path.addLine(to: CGPoint(x: 100, y: 300))
                    path.addLine(to: CGPoint(x: 300, y: 300))
                    path.addLine(to: CGPoint(x: 200, y: 100))
                    path.addLine(to: CGPoint(x: 100, y: 300))
                    path.addRect(CGRect(x: 0, y: 0, width: 100, height: 100))
                    path.addArc(center: CGPoint(x: 100, y: 100), radius: 100, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 270), clockwise: true)
                }
                .stroke(Color.blue.opacity(0.2), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 10))
//                .fill(.angularGradient(colors: [.accentColor,.cyan], center: .center, startAngle: .degrees(0), endAngle: .degrees(180)))
                
                CanvasView()
            }
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
