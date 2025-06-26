import SwiftUI

@main
struct MoodTunesApp: App {
    @StateObject var moodVM = MoodViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                ChatView()
                    .tabItem {
                        Label("Jenny", systemImage: "bubble.left.and.bubble.right.fill")
                    }
            }
            .environmentObject(moodVM)
        }
    }
}
