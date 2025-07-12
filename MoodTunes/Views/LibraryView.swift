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
    @EnvironmentObject var shortcutHandler: ShortcutHandler
    @State private var selection = Set<UUID>()
    @State private var editMode: EditMode = .inactive
    @State private var autoPlay: Bool = false
    @State private var autoTracks: [Track] = []

    var body: some View {
        NavigationStack {
            List(selection: $selection) {
                ForEach(libraryVM.playlists.indices, id: \.self) { index in
                    HStack {
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

                        Spacer()

                        if !editMode.isEditing {
                            Button(role: .destructive) {
                                libraryVM.playlists.remove(at: index)
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .tag(libraryVM.playlists[index].id)
                }
            }
            .navigationTitle("🎧 Your Library")
            .environment(\.editMode, $editMode)
            .toolbar {
                EditButton()
                if !selection.isEmpty {
                    Button(role: .destructive) {
                        libraryVM.deletePlaylists(ids: selection)
                        selection.removeAll()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .onReceive(shortcutHandler.$playRequested) { value in
                guard value else { return }
                if let playlist = libraryVM.playlists.first,
                   !playlist.tracks.isEmpty {
                    autoTracks = playlist.tracks
                    autoPlay = true
                }
                shortcutHandler.playRequested = false
            }
            .sheet(isPresented: $autoPlay) {
                NowPlayingView(tracks: autoTracks, currentIndex: 0)
            }
        }
    }
}

struct PlaylistDetailView: View {
    @Binding var playlist: Playlist
    @State private var tracks: [Track] = []
    @State private var selectedTrack: SelectedTrack?
    @State private var selection = Set<String>()
    @State private var editMode: EditMode = .inactive

    var body: some View {
        List(selection: $selection) {
            Section {
                TextField("Playlist Name", text: $playlist.title)
                    .font(.headline)
            }

            ForEach(tracks.indices, id: \.self) { index in
                SongCard(
                    track: tracks[index],
                    reason: "From \(playlist.title)",
                    onTap: {
                        selectedTrack = SelectedTrack(index: index)
                    },
                    onDelete: editMode.isEditing ? nil : {
                        tracks.remove(at: index)
                        playlist.tracks = tracks
                    }
                )
                .tag(tracks[index].id)
            }
        }
        .navigationTitle("\(playlist.emoji) \(playlist.title)")
        .environment(\.editMode, $editMode)
        .toolbar {
            EditButton()
            if !selection.isEmpty {
                Button(role: .destructive) {
                    deleteSelectedTracks()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
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

    func deleteSelectedTracks() {
        tracks.removeAll { selection.contains($0.id) }
        playlist.tracks = tracks
        selection.removeAll()
    }
}
