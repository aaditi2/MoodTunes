import SwiftUI
import AVFoundation

struct NowPlayingView: View {
    let tracks: [Track]
    @State var currentIndex: Int

    @State private var player: AVPlayer?
    @State private var isPlaying = true
    @State private var currentTime: Double = 0
    @State private var duration: Double = 30
    @State private var isRepeat = false

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        let track = tracks[currentIndex]

        VStack(spacing: 20) {
            Spacer()

            AsyncImage(url: URL(string: track.coverURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 300, height: 300)
            .cornerRadius(20)
            .shadow(radius: 10)

            Text(track.title)
                .font(.title2)
                .bold()

            Text(track.artist)
                .font(.subheadline)
                .foregroundColor(.gray)

            // Seek Bar
            Slider(value: $currentTime, in: 0...duration)
                .accentColor(.green)
                .padding(.horizontal)

            // Full Controls Bar
            HStack(spacing: 20) {
                // Repeat
                Button {
                    isRepeat.toggle()
                } label: {
                    Image(systemName: isRepeat ? "repeat.circle.fill" : "repeat")
                        .font(.title2)
                        .foregroundColor(isRepeat ? .green : .primary)
                }

                // Previous Track
                Button {
                    playPrevious()
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.title2)
                }

                // Back 5 sec
                Button {
                    seek(by: -5)
                } label: {
                    Image(systemName: "gobackward.5")
                        .font(.title2)
                }

                // Play / Pause
                Button {
                    togglePlayback()
                } label: {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }

                // Forward 5 sec
                Button {
                    seek(by: 5)
                } label: {
                    Image(systemName: "goforward.5")
                        .font(.title2)
                }

                // Next Track
                Button {
                    playNext()
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.title2)
                }
            }
            .frame(height: 80)

            Spacer()
        }
        .padding()
        .onAppear { play(track) }
        .onDisappear { player?.pause() }
        .onReceive(timer) { _ in
            guard let currentItem = player?.currentItem else { return }
            currentTime = currentItem.currentTime().seconds

            if currentTime >= duration {
                if isRepeat {
                    player?.seek(to: .zero)
                    player?.play()
                    currentTime = 0
                } else {
                    playNext()
                }
            }
        }
    }

    // MARK: Playback Functions

    func togglePlayback() {
        guard let player = player else { return }
        isPlaying.toggle()
        isPlaying ? player.play() : player.pause()
    }

    func seek(by seconds: Double) {
        guard let player = player else { return }
        let newTime = max(0, min(duration, currentTime + seconds))
        let cmTime = CMTime(seconds: newTime, preferredTimescale: 600)
        player.seek(to: cmTime)
        currentTime = newTime
    }

    func play(_ track: Track) {
        player?.pause() // ✅ Stop previous playback

        SpotifyService.shared.fetchPreviewURL(for: track.id) { url in
            if let url = url, let audioURL = URL(string: url) {
                DispatchQueue.main.async {
                    player = AVPlayer(url: audioURL)
                    player?.play()
                    isPlaying = true
                    currentTime = 0
                }
            }
        }
    }

    func playNext() {
        player?.pause() // ✅ Stop current song
        if currentIndex < tracks.count - 1 {
            currentIndex += 1
            play(tracks[currentIndex])
        }
    }

    func playPrevious() {
        player?.pause() // ✅ Stop current song
        if currentTime > 3 {
            player?.seek(to: .zero)
            currentTime = 0
            player?.play()
        } else if currentIndex > 0 {
            currentIndex -= 1
            play(tracks[currentIndex])
        }
    }
}
