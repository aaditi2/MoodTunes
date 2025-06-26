import SwiftUI
import Combine

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
                        Label("Sara", systemImage: "bubble.left.and.bubble.right.fill")
                    }

                MoodMapView()
                    .tabItem {
                        Label("MoodMap", systemImage: "calendar")
                    }

                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }

                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "magnifyingglass")
                    }
            }
            .environmentObject(moodVM)
        }
    }
}

