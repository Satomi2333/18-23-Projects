import SwiftUI

class Source: Codable {
    var name: String
    var color: MyColor
    
    init(name n: String, color c: MyColor){
        name = n
        color = c
    }
}
