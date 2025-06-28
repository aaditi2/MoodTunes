# 🎧 MoodTunes

**MoodTunes** is a SwiftUI-based music discovery app that helps you find songs based on your **specific situation** — not just your mood or vibe. Powered by conversational AI and real-time Spotify suggestions, MoodTunes creates personalized playlists that understand your **situation**, **language**, and **vibe** — like a musical therapist in your pocket.

## Folder Structure

```
MoodTunes/
├── App/            # Application entry points
├── Views/          # All SwiftUI views
│   └── Components/ # Reusable view components
├── ViewModels/     # Observable view models
├── Models/         # Data models
├── Services/       # Networking and API helpers
└── Resources/      # Assets and entitlements
```


---

## 🚀 Key Features

- 💬 **Chat with Sara**:  A Gen-Z conversational music AI therapist.

-  🧠 **Situation-Aware Song Suggestions**

-  🗓️ **Mood Map Calendar**:  Visualizes your emotional listening journey across the month.

-  🧽 **Smart Track Filtering**:  Only shows songs released after 2010 for fresh, relevant vibes.

-  🗂️ **Custom Playlist Library**:  Save and edit playlists suggested by Sara.

-  🌈 **Multilingual Filters**

-  🎙️ **Voice Input**

---

## Technologies Used

- **SwiftUI** — Declarative and reactive UI architecture
- **Combine** — Real-time state management with `@State`, `@ObservedObject`
- **AVFoundation** — Built-in voice recording and transcription
- **NavigationStack** — Seamless transitions between chat, discovery, and player
- **URLSession** — For Spotify & Together.ai API calls
- **CoreLocation** *(planned)* — Mood-based recommendations using location (e.g., rainy days)

---

## 💡 Why MoodTunes is Different

**MoodTunes is emotionally intelligent**:

> You *talk* about your situation and feelings.  
> Sara, the built-in Gen-Z AI therapist, replies like a comforting friend — then matches your vibe with situationally resonant tracks.

No more typing "sad songs Hindi" — Sara gets you.

---

## 📸 UI Screenshots

<img width="375" alt="MoodTunes_HomePage" src="https://github.com/user-attachments/assets/3977216e-2a21-4c17-b89f-bda7a3b7a5e2" />
<img width="375" <img width="372" alt="MoodTunes_ChatPage4" src="https://github.com/user-attachments/assets/e62bdc4f-fa17-4ef0-94f5-231c634e1f3b" />
<img width="377" alt="MoodTunes_ChatPage5" src="https://github.com/user-attachments/assets/c87d6597-f81b-4a08-b789-125865499188" />
<img width="366" alt="MoodTunes_DiscoverPage" src="https://github.com/user-attachments/assets/5f1c1087-8f91-4ced-9842-a90e654168d9" />
<img width="365" alt="MoodTunes_Library" src="https://github.com/user-attachments/assets/2990b38c-3f85-4f68-bdc3-6cb8750c16a4" />
<img width="369" alt="MoodTunes_MoodMap" src="https://github.com/user-attachments/assets/a69950de-2aae-4210-a561-2579cb487ffa" />




All source files remain under the `MoodTunes` group so the Xcode project
continues to work without additional changes.
