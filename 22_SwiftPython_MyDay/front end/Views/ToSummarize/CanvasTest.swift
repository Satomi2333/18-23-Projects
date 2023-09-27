import SwiftUI

struct MyShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: 5, height: 5))
        }
    }
}

struct CavansTest: View {
    var body: some View {
        
        VStack{
            Canvas { context, size in
                var lines = Path()
                
                for i in 0..<24 {
                    lines.move(to: CGPoint(x: i*10, y: 0))
                    lines.addLine(to: CGPoint(x: i*10, y: 1000))
                }
                context.stroke(lines, with: .color(.accentColor.opacity(0.1)))
                
                lines = Path()
                lines.move(to: CGPoint(x: 100, y: 100))
                lines.addLine(to: CGPoint(x: 200, y: 100))
                context.stroke(lines, with: .color(.accentColor.opacity(0.8)), style: StrokeStyle(lineWidth: 1))
                
                lines.addRoundedRect(in: CGRect(x: 100, y: 120, width: 100, height: 10), cornerSize: CGSize(width: 5, height: 5))
                lines.addEllipse(in: CGRect(x: 100, y: 150, width: 100, height: 15))
                
                context.fill(lines, with: .color(.accentColor))
                lines.addEllipse(in: CGRect(x: 100, y: 300, width: 100, height: 15))
                
//                MyShape().path(in: CGRect(x: 100, y: 200, width: 100, height: 15)).fill(.blue) // Shape.fill() -> View
                for i in 0..<5 {
                    lines = Path()
                    lines.addRoundedRect(in: CGRect(x: 30*i, y: 20, width: 20, height: 5), cornerSize: CGSize(width: 3, height: 3))
                    context.fill(lines, with: .color(.random()))
                }
            }
            
            CanvasView()
            MyShape().path(in: CGRect(x: 100, y: 0, width: 100, height: 15)).fill(.blue)
        }
    }
}

struct CavansTest_Previews: PreviewProvider {
    static var previews: some View {
        CavansTest()
//            .background(){
//                Color.accentColor
//            }
            .foregroundColor(.black)
    }
}
