#if os(watchOS)
import SwiftUI

@main
struct MoodTunesWatchApp: App {
    @StateObject private var moodVM = MoodViewModel()

    var body: some Scene {
        WindowGroup {
            WatchHomeView()
                .environmentObject(moodVM)
        }
    }
}
#endif
