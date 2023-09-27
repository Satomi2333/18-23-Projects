import SwiftUI

struct MyColorOldVersion: Codable {
    var r : Int
    var g : Int
    var b : Int
    
    init(red: Int, green: Int, blue: Int){
        r = red
        g = green
        b = blue
    }
    
    func toColor() -> Color {
        return Color(red: Double(r)/255.0, green: Double(g)/255, blue: Double(b)/255.0)
    }
    
    static func random() -> Color {
        return Color.random()
    }
    
    static func random() -> MyColorOldVersion {
        return MyColorOldVersion(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))
    }
}
