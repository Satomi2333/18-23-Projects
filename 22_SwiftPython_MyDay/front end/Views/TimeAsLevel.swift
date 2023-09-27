import SwiftUI

struct TimeAsView {
    private var symbols: [String] = []
    private var threshoulds: [Int] = []
    private var base: Base = .hour
    private var multiple: Int = 1
    
    enum Base: Int {
        case second = 1
        case minute = 60
        case hour = 3600
        case day = 86400 //24*3600
        case week = 604800
        case month30 = 2592000
        case year365 = 31536000
    }
    
    init(symbols: [String], threshoulds: [Int], base: Base = .day, multiple: Int = 1){
        guard symbols.count == threshoulds.count else{print("invalid tav");return}
        self.symbols = symbols
        self.threshoulds = threshoulds
        self.base = base
        self.multiple = multiple
    }
    
    init(symbols: [String], xSystem: Int, base: Base = .day, mutiple m: Int = 1){
        self.symbols = symbols
        var tempThre :[Int] = []
        var tempX = 1
        for _ in 0..<symbols.count {
//            tempThre.append(pow(.init(xSystem), i))
            tempThre.append(tempX)
            tempX *= xSystem
        }
        self.threshoulds = tempThre
        self.base = base
        self.multiple = m
    }
    
    func getSymbolString(by value: Int, length: Int) -> String {
        var s = ""
        if length == 0{
            return s
        }
//        var emojiList: [String] = []
        var valueNew: Int = value/base.rawValue/multiple
        for i in (0..<symbols.count).reversed() {
            let threshould = threshoulds[i]
            let symbol = symbols[i]
            let count = valueNew/threshould
            let symbolCount = String(repeating: symbol, count: count)
            
            s += symbolCount
//            for _ in 0..<count {
//                emojiList.append(symbol)
//            }
            valueNew -= count * threshould
        }
//        var s = String(describing: emojiList)
        if length > 0 {
            return String(s[s.startIndex..<s.index(s.startIndex, offsetBy: min(s.count, length))])
        } else {
            return s
        }
        
    }
    
    static let tav_qq_day = TimeAsView(symbols: ["⭐️","🌙","☀️","👑"], threshoulds: [1,4,16,64], base: .day, multiple: 10)
    static let tav_qq_count = TimeAsView(symbols: ["⭐️","🌙","☀️","👑"], threshoulds: [1,4,16,64], base: .second, multiple: 1)
}

struct TimeAsLevelView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

struct TimeAsLevelViewTest: View {
    @State var testInt = 90
    @State var length = -1
    @State var c = 1
    @State var tempHue = 0.0
    let colors : [Color] = [.yellow, .green, .blue, .purple, .orange, .red]
    let hueRotation: [Double] = [0, 45, 170, 200, 336, 300]
    
    var body: some View {
        VStack {
            Stepper("value \(testInt)", value: $testInt)
            Stepper("length \(length)", value: $length)
            Text("hue:\(tempHue)")
            Slider(value: $tempHue, in: 0...360){Text("hue:\(tempHue)")}
            Picker("choose a color",selection: $c){
                Text("yellow").tag(0)
                Text("green").tag(1)
                Text("blue").tag(2)
                Text("purple").tag(3)
                Text("orange").tag(4)
                Text("red").tag(5)
                
            }.pickerStyle(.segmented)
            Text("tav_qq_day: \(TimeAsView.tav_qq_count.getSymbolString(by: testInt, length: length))")
                .foregroundColor(.yellow)
                .hueRotation(Angle(degrees: hueRotation[c]))
//                .hueRotation(Angle(degrees: tempHue))
                .shadow(color: colors[c], radius: 3, x: 0.0, y: 0.0)
        }
    }
}

struct TimeAsLevelView_Previews: PreviewProvider {
    static var previews: some View {
        TimeAsLevelViewTest()
//            .environment(\.colorScheme, .dark)
    }
}
