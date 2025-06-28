import SwiftUI
import Combine

@main
struct MoodTunesApp: App {
    @StateObject var moodVM = MoodViewModel()
    @StateObject var libraryVM = LibraryViewModel()

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

                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "magnifyingglass")
                    }

                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }
                
                MoodMapView()
                    .tabItem {
                        Label("MoodMap", systemImage: "calendar")
                    }

            }
            .environmentObject(moodVM)
            .environmentObject(libraryVM)
        }
    }
}

