import SwiftUI

struct Playlist: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
}

let mockPlaylists = [
    Playlist(title: "Cried & Vibed 💔", emoji: "😭"),
    Playlist(title: "Glow Up Energy 💅", emoji: "✨"),
    Playlist(title: "Lo-fi Heartbreak", emoji: "🌧"),
    Playlist(title: "Main Character Mode", emoji: "🎬")
]

struct LibraryView: View {
    var body: some View {
        NavigationView {
            List(mockPlaylists) { playlist in
                HStack {
                    Text(playlist.emoji)
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(playlist.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Tap to open")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 6)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("🎧 Your Library")
            .background(Color.black)
        }
    }
}
