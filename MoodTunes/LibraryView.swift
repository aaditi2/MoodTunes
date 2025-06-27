import SwiftUI

// MARK: - Models

struct Playlist: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let queries: [String]
    var tracks: [Track] = []
}

// Used for sheet presentation
struct SelectedTrack: Identifiable {
    let id = UUID()
    let index: Int
}

// MARK: - Views

struct LibraryView: View {
    @State private var playlists: [Playlist] = [
        Playlist(title: "Leaving country to study abroad!", emoji: "✈️", queries: [
            "Ilahi", "Safarnama", "Zindagi", "Dil Dhadakne Do", "Phir Se Ud Chala", "Musafir", "Patakha Guddi"
        ]),
        Playlist(title: "Main Character Vibes", emoji: "🎬", queries: [
            "Desi Girl", "Drama Queen", "Dhoom Again", "Chak Lein De", "Girls Like To Swing", "Swag Se Swagat", "Sheila Ki Jawani"
        ]),
        Playlist(title: "Your Job Search Grind", emoji: "💪", queries: [
            "Kar Har Maidan Fateh", "Zinda", "Lakshya", "Apna Time Aayega"
        ])
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(playlists.indices, id: \.self) { index in
                    NavigationLink(destination: PlaylistDetailView(playlist: playlists[index])) {
                        HStack {
                            Text(playlists[index].emoji)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(playlists[index].title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Tap to explore")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("🎧 Your Library")
        }
    }
}

struct PlaylistDetailView: View {
    let playlist: Playlist
    @State private var tracks: [Track] = []
    @State private var selectedTrack: SelectedTrack?

    var body: some View {
        List {
            ForEach(tracks.indices, id: \.self) { index in
                SongCard(track: tracks[index], reason: "From \(playlist.title)") {
                    selectedTrack = SelectedTrack(index: index)
                }
            }
        }
        .navigationTitle("\(playlist.emoji) \(playlist.title)")
        .onAppear {
            fetchAllTracks()
        }
        .sheet(item: $selectedTrack) { selected in
            NowPlayingView(tracks: tracks, currentIndex: selected.index)
        }
    }

    func fetchAllTracks() {
        var allFetched: [Track] = []
        let group = DispatchGroup()

        for query in playlist.queries {
            group.enter()
            SpotifyService.shared.searchTracks(query: query) { result in
                allFetched.append(contentsOf: result)
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.tracks = allFetched
        }
    }
}
