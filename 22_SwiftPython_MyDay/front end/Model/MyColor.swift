import SwiftUI

class MyColor: Codable {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var alpha: CGFloat
    var space : Space = .srgb
    
    enum CodingKeys: String, CodingKey {
        case r,g,b,alpha,space
    }
    
    enum Space: String, Codable {
        case srgb
        case p3
    }
    
    init(r:CGFloat, g:CGFloat, b:CGFloat, a:Float) {
        self.r = r
        self.g = g
        self.b = b
        self.alpha = CGFloat(a)
    }
    
    init(cgcolor: CGColor) {
        let colorSpaceName : CGColorSpace = cgcolor.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
        let colorComponents = cgcolor.components!
        if colorComponents.count == 4 {
            r = colorComponents[0]
            g = colorComponents[1]
            b = colorComponents[2]
            alpha = colorComponents[3]
        } else {
            fatalError("cant convert cgcolor to mycolor")
        }
        switch colorSpaceName {
        case CGColorSpace(name: CGColorSpace.sRGB): space = Space.srgb
        case CGColorSpace(name: CGColorSpace.displayP3): space = Space.p3
        default:space = Space.srgb
        }
    }
    
    func toCGColor() -> CGColor {
        return CoreGraphics.CGColor(colorSpace: colorSpace, components: [r,g,b,alpha])!
    }
    
    func toColor() -> Color {
        return Color(toCGColor()).opacity(alpha)
    }
    
    func toBrighterColor() -> Color {
//        return Color(red: r+(1-r)*0.1, green: g+(1-g)*0.1, blue: b+(1-b)*0.1).opacity(alpha*0.8)
        return Color(red: r*0.8, green: g*0.8, blue: b*0.8).opacity(alpha*0.8)
    }
    
    var colorSpace: CGColorSpace {
        switch space {
        case .srgb : return CGColorSpace(name: CGColorSpace.sRGB)!
        case .p3 : return CGColorSpace(name: CGColorSpace.displayP3)!
        }
    }
    
    static func random() -> MyColor {
        return MyColor(r: .random(in: 0...1), g: .random(in: 0...1), b: .random(in: 0...1), a: .random(in: 0.5...1))
    }
    
    static func random() -> CGColor {
        return MyColor.random().toCGColor()
    }
    
}

extension MyColor: Equatable {
    static func == (lop: MyColor, rop: MyColor) -> Bool {
        return lop.toCGColor() == rop.toCGColor()
    }
}
