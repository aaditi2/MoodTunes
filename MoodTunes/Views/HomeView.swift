import SwiftUI
import Foundation

struct Album: Identifiable, Codable {
    let id: String
    let name: String
    let coverUrl: String
    let artist: String
}

struct Artist: Identifiable, Codable {
    let id: String
    let name: String
    let imageUrl: String
}

struct AlbumDetailView: View {
    let album: Album

    var body: some View {
        VStack {
            Text("💿 \(album.name)")
                .font(.title)
                .bold()
            Text("by \(album.artist)")
        }
        .navigationTitle(album.name)
    }
}

struct ArtistDetailView: View {
    let artist: Artist

    var body: some View {
        VStack {
            Text("🎤 \(artist.name)")
                .font(.title)
                .bold()
        }
        .navigationTitle(artist.name)
    }
}

struct HomeView: View {
    @EnvironmentObject var moodVM: MoodViewModel

    @State private var popularArtists: [Artist] = []
    @State private var bollywoodAlbums: [Album] = []
    @State private var taylorTracks: [Track] = []

    var body: some View {
        NavigationStack {
            ZStack {
                moodVM.currentMood.gradient
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 1.0), value: moodVM.currentMood)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // 🌟 Welcome
                        Text("Welcome to MoodTunes 💖")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top)

                        // 🎭 Mood Buttons
                        HStack {
                            moodButton(title: "Glow Up", tag: "glowup")
                            moodButton(title: "Rage", tag: "rage")
                            moodButton(title: "Chill", tag: "chill")
                        }
                        .padding(.horizontal)

                        // 🔥 Popular Artists
                        Text("🔥 Popular Artists")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(popularArtists) { artist in
                                    NavigationLink(destination: ArtistDetailView(artist: artist)) {
                                        VStack {
                                            AsyncImage(url: URL(string: artist.imageUrl)) { image in
                                                image.resizable().aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                            .clipped()

                                            Text(artist.name)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .frame(width: 80)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // 🎬 Bollywood Albums
                        Text("🎬 Top Bollywood Albums")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(bollywoodAlbums) { album in
                                    NavigationLink(destination: AlbumDetailView(album: album)) {
                                        VStack(alignment: .leading) {
                                            AsyncImage(url: URL(string: album.coverUrl)) { image in
                                                image.resizable().aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(10)
                                            .clipped()

                                            Text(album.name)
                                                .font(.caption)
                                                .lineLimit(1)
                                                .foregroundColor(.white)

                                            Text(album.artist)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 120)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // ✨ Taylor Swift Songs
                        Text("✨ Top Taylor Swift Songs")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(taylorTracks) { track in
                                    NavigationLink(destination:
                                        NowPlayingView(
                                            tracks: taylorTracks,
                                            currentIndex: taylorTracks.firstIndex(where: { $0.id == track.id }) ?? 0
                                        )
                                    ) {
                                        VStack(alignment: .leading) {
                                            AsyncImage(url: URL(string: track.coverURL)) { image in
                                                image.resizable().aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(10)
                                            .clipped()

                                            Text(track.title)
                                                .font(.caption)
                                                .lineLimit(1)
                                                .foregroundColor(.white)

                                            Text(track.artist)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 120)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                    }
                    .padding(.bottom, 40)
                }
            }
            .onAppear {
                SpotifyService.shared.fetchPopularArtists { artists in
                    self.popularArtists = artists
                }
                SpotifyService.shared.fetchBollywoodAlbums { albums in
                    self.bollywoodAlbums = albums
                }
                SpotifyService.shared.searchTracks(query: "Taylor Swift") { tracks in
                    self.taylorTracks = tracks
                }
            }
        }
    }

    // 🎭 Mood button component
    func moodButton(title: String, tag: String) -> some View {
        Button("Mood ➡️ \(title)") {
            moodVM.updateMoodBasedOnEmotionTag(tag)
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.2))
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}
