import SwiftUI

class ScreenTimeApp : Codable{
    var name: String
    var color: MyColor
    var belongsTodo: String
    var belongsTodoSub: String
    
    init(name n: String, color c: MyColor, todoId: String, todoSubId: String) {
        name = n
        color = c
        belongsTodo = todoId
        belongsTodoSub = todoSubId
    }
}
