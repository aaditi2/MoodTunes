import SwiftUI
import AVFoundation
import Combine


struct DiscoverView: View {
    @State private var query = ""
    @State private var results: [Track] = []
    @State private var isLoading = false
    @State private var selectedTrack: Track?

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Search for a song", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Search") {
                    search()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                if isLoading {
                    ProgressView("Searching...")
                        .padding()
                }

                List(results) { track in
                    HStack {
                        AsyncImage(url: URL(string: track.coverURL)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text(track.title).bold()
                            Text(track.artist).font(.caption).foregroundColor(.gray)
                        }

                        Spacer()

                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                    .padding(.vertical, 6)
                    .onTapGesture {
                        selectedTrack = track
                    }
                }
                .listStyle(.plain)

                // Navigate to NowPlayingView with full controls
                if let selectedTrack = selectedTrack,
                   let selectedIndex = results.firstIndex(where: { $0.id == selectedTrack.id }) {
                    NavigationLink(
                        destination: NowPlayingView(tracks: results, currentIndex: selectedIndex),
                        isActive: Binding(
                            get: { self.selectedTrack != nil },
                            set: { if !$0 { self.selectedTrack = nil } }
                        ),
                        label: { EmptyView() }
                    )
                    .hidden()
                }
            }
            .navigationTitle("MoodTunes")
        }
    }

    func search() {
        isLoading = true
        results = []
        selectedTrack = nil

        SoundCloudService.shared.searchTracks(query: query) { tracks in
            DispatchQueue.main.async {
                self.results = tracks
                self.isLoading = false
            }
        }
    }
}
