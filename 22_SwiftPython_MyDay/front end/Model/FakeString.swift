import SwiftUI

class FakeString: Codable, ObservableObject {
    @Published var show: String
    @Published var real: String
    
    private enum CoderKeys: String, CodingKey {
        case show,real
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        show = try values.decode(String.self, forKey: .show)
        real = try values.decode(String.self, forKey: .real)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(show, forKey: .show)
        try container.encode(real, forKey: .real)
    }
    
    init(_ show: String){
        self.show = show
        self.real = show
    }
    
    init(show: String, real: String){
        self.show = show
        self.real = real
    }
    
//    required init(stringLiteral:) {
//        <#statements#>
//    }
    
//    func setShow(toShow: String){
//        show = toShow
//    }
    
    func value(_ showReal: Bool) -> String {
        return showReal ? real : show
    }
    
    var notNil: Bool {
        return (self.show != "")
    }
    
    static func random(length: Int = 5, icon: Bool = false) -> FakeString {
        return FakeString(show: String.random(length: length,icon: icon), real: String.random(length: length, icon: icon))
    }
    
    func checkNone() {
        if real == "" {
            real = show
        }
    }
}
