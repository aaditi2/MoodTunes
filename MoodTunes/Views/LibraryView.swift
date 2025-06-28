import SwiftUI

// MARK: - Models

struct Playlist: Identifiable {
    let id = UUID()
    var title: String
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
    @EnvironmentObject var libraryVM: LibraryViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(libraryVM.playlists.indices, id: \.self) { index in
                    NavigationLink(destination: PlaylistDetailView(playlist: $libraryVM.playlists[index])) {
                        HStack {
                            Text(libraryVM.playlists[index].emoji)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(libraryVM.playlists[index].title)
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
    @Binding var playlist: Playlist
    @State private var tracks: [Track] = []
    @State private var selectedTrack: SelectedTrack?

    var body: some View {
        List {
            Section {
                TextField("Playlist Name", text: $playlist.title)
                    .font(.headline)
            }

            ForEach(tracks.indices, id: \.self) { index in
                SongCard(track: tracks[index], reason: "From \(playlist.title)") {
                    selectedTrack = SelectedTrack(index: index)
                }
            }
            .onDelete { offsets in
                tracks.remove(atOffsets: offsets)
                playlist.tracks = tracks
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
        if !playlist.tracks.isEmpty {
            self.tracks = playlist.tracks
            return
        }

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
            playlist.tracks = allFetched
        }
    }
}
