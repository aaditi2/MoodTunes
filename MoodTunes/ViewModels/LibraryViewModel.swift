import SwiftUI

class LibraryViewModel: ObservableObject {
    @Published var playlists: [Playlist]

    init() {
        playlists = [
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
    }

    func addPlaylist(title: String, tracks: [Track]) {
        let new = Playlist(title: title, emoji: "🎵", queries: [], tracks: tracks)
        playlists.append(new)
    }

    func deletePlaylists(ids: Set<UUID>) {
        playlists.removeAll { ids.contains($0.id) }
    }
}
