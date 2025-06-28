# MoodTunes

MoodTunes is a SwiftUI application for discovering music based on your mood.

## Folder Structure

```
MoodTunes/
├── App/            # Application entry points
├── Views/          # All SwiftUI views
│   └── Components/ # Reusable view components
├── ViewModels/     # Observable view models
├── Models/         # Data models
├── Services/       # Networking and API helpers
├── Resources/      # Assets and entitlements
└── Config/         # Local configuration such as API keys
```

All source files remain under the `MoodTunes` group so the Xcode project
continues to work without additional changes.

## YouTube Music API Endpoints

MoodTunes now interacts with the YouTube Music API in place of the older
SoundCloud logic. The service layer exposes helper methods for the following
endpoints:

- `/popular/search` – search for popular songs by query and language.
- `/popular/categories` – get popular song categories by language.
- `/popular/trends` – fetch trending songs by country.
- `/get_artist_albums` – retrieve albums for an artist using `channel_id`.
- `/get_artist` – get artist information using `channel_id`.
- `/get_user` – fetch user information using `user_id`.
- `/get_user_playlists` – list public playlists of a user.
- `/get_song` – detailed info for a song using `video_id`.
- `/get_song_related` – related songs using `browse_id`.
- `/get_lyrics` – lyrics for a song using `browse_id`.
- `/get_album` – album details using `browse_id`.
