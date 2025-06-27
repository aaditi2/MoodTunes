import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Sara")
                }

            MoodMapView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("MoodMap")
                }

            LibraryView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Library")
                }

            DiscoverView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(MoodViewModel())
}

#Preview {
    DiscoverView()
        .environmentObject(MoodViewModel())
}

