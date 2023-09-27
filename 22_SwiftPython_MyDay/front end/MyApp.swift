import SwiftUI

@main
struct MyApp: App {
    private var todoModel = TodoModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserSetting(show: false))
                .environmentObject(todoModel)
                .environment(\.locale, Locale(identifier: "zh"))
        }
    }
}
