import SwiftUI
import Combine

@main
struct MoodTunesApp: App {
    @StateObject var moodVM = MoodViewModel()
    @StateObject var libraryVM = LibraryViewModel()
    @StateObject var shortcutHandler = ShortcutHandler()
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)

                ChatView()
                    .tabItem {
                        Label("Sara", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                    .tag(1)

                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "magnifyingglass")
                    }
                    .tag(2)

                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }
                    .tag(3)

                MoodMapView()
                    .tabItem {
                        Label("MoodMap", systemImage: "calendar")
                    }
                    .tag(4)

            }
            .environmentObject(moodVM)
            .environmentObject(libraryVM)
            .environmentObject(shortcutHandler)
            .onOpenURL { handleURL($0) }
        }
    }
}

extension MoodTunesApp {
    func handleURL(_ url: URL) {
        guard url.scheme == "moodtunes" else { return }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        switch url.host {
        case "search":
            if let query = components?.queryItems?.first(where: { $0.name == "situation" })?.value {
                shortcutHandler.searchQuery = query
            }
            selectedTab = 2
        case "chat":
            if let message = components?.queryItems?.first(where: { $0.name == "message" })?.value {
                shortcutHandler.chatMessage = message
            }
            selectedTab = 1
        case "play":
            shortcutHandler.playRequested = true
            selectedTab = 3
        default:
            break
        }
    }
}

