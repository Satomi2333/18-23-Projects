import SwiftUI

extension Color {
    static let pink13: Color = Color(red: 250/255, green: 221/255, blue: 215/255)
//    static let dark = Color(uiColor: .systemBackground)
    static let dark = Color(red: 28/255, green: 28/255, blue: 29/255)
    
    static func random() -> Color {
        return Color(
            red: .random(in: 0...1), 
            green: .random(in: 0...1),
            blue: .random(in: 0...1))
    }
    
}

extension CGColor {
    static func random() -> CGColor {
        return CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!,components: [.random(in: 0...1), .random(in:0...1), .random(in:0...1), .random(in: 0...1)])!
    }
}

extension Character {
    static let charsLen = 36
}

extension String {
    static let chars = "abcdefghijklmnopqrstuvwxyz0123456789一些测试的中文字符串反正是随机的也不知道哪个元素会被抽到我就一直写只到我编不下去好吧还是用一些其他字符来凑数吧🐶🐱😭😅😚😉☺️🤤🤔😼👻👍,./<>?;':\"[]{}!@#$%^&*()-=_+`~\\|¡™£¢∞§¶•ªº–≠«‘“æ…÷≥≤œ∑®†¥øπ¬˚∆˙©ƒ∂ßåΩ≈ç√∫≤≥÷…æ"
    static let chars2 = ""
//    static let charss:[String] = ["a","b","c","d","e"]
    static let charss : [String] = chars.map(String.init)
    static func random(length: Int = 5, icon: Bool = false) -> String{
        if icon {
            return IconSelector.icons.randomElement() ?? "sun.max"
        }
        var temp = ""
        let randomStep = Int.random(in: 1..<length)
        for _ in 0 ..< Int.random(in: length-randomStep ..< length) {
            temp += charss.randomElement() ?? "a"
        }
        return temp
    }
    
    static let nothing = ""
}

extension Date {
    static func getHHmm(date d: Date) -> (hour: Int, minute: Int){
        let dateF = DateFormatter()
        dateF.dateFormat = "HH:mm"
        let temp = dateF.string(from: d)
        let HHmm = temp.split(separator: ":")
        let hour = Int(HHmm[0])!
        let minute = Int(HHmm[1])!
//        print("\(hour) \(minute)")
        return (hour,minute)
    }
    
    static func getRelativeOfDay(date d: Date) -> Double {
        let HHmm = Date.getHHmm(date: d)
//        print((Double(HHmm.hour) + Double(HHmm.minute)/60.0))
        return (Double(HHmm.hour) + Double(HHmm.minute)/60.0)/24
    }
    
    static func - (l: Date, r: Date) -> Int {
        return Int(l.timeIntervalSince(r))
    }
}

extension Int {
    static func toHour(_ value: Int) -> String {
        let hours : Int = value / 3600
        let minutes : Int = (value - hours * 3600) / 60
        let seconds : Int = value % 60
        if hours != 0 {
            return "\(hours)时\(minutes)分"
        } else {
            if minutes != 0 {
                return "\(minutes)分\(seconds)秒"
            } else {
                return "\(seconds)秒"
            }
        }
        
    }
}
