import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @State private var suggestedTracks: [SuggestedTrack] = []
    @State private var isLoading = false
    @State private var selectedTrack: Track?
    @State private var situation: String = ""

    @EnvironmentObject var libraryVM: LibraryViewModel
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false

    @State private var selectedLanguages: Set<String> = ["Hindi"]
    let allLanguages = ["Hindi", "English", "Punjabi", "Tamil", "Telugu", "Marathi", "Malayalam"]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubbleView(message: message)
                        }

                        ForEach(suggestedTracks) { suggestion in
                            SongCard(
                                track: suggestion.track,
                                reason: suggestion.reason,
                                onTap: {
                                    selectedTrack = suggestion.track
                                }
                            )
                        }
                    }
                    .padding()
                }

                LanguagePicker(allLanguages: allLanguages, selectedLanguages: $selectedLanguages)
                    .padding(.horizontal)

                HStack {
                    TextField("Tell Sara what you're feeling...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isLoading)

                    Button(action: toggleRecording) {
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    }
                    .padding(.trailing, 4)

                    Button("Send") {
                        send()
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                }
                .padding()
                
                if !suggestedTracks.isEmpty {
                    Button("Save Playlist") {
                        savePlaylist()
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Chat with Sara 💚")
            .background(navigationLinkToNowPlaying)
            .onChange(of: speechRecognizer.transcript) { newValue in
                if isRecording {
                    inputText = newValue
                }
            }
        }
    }

    var navigationLinkToNowPlaying: some View {
        NavigationLink(
            destination: NowPlayingView(
                tracks: suggestedTracks.map { $0.track },
                currentIndex: suggestedTracks.firstIndex(where: { $0.track.id == selectedTrack?.id }) ?? 0
            ),
            isActive: Binding(get: { selectedTrack != nil }, set: { if !$0 { selectedTrack = nil } })
        ) {
            EmptyView()
        }
        .hidden()
    }

    func send() {
        if isRecording { toggleRecording() }
        let prompt = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty else { return }

        messages.append(Message(text: prompt, isUser: true))
        situation = prompt
        inputText = ""
        isLoading = true
        suggestedTracks = []

        TogetherService.shared.askSara(userInput: prompt, languageTags: Array(selectedLanguages)) { response in
            DispatchQueue.main.async {
                let trimmedReply = response.reply.components(separatedBy: ". ").prefix(2).joined(separator: ". ")
                messages.append(Message(text: trimmedReply, isUser: false))
                fetchSongs(for: situation)
                isLoading = false
            }
        }
    }

    func fetchSongs(for situation: String) {
        let query = ([situation] + Array(selectedLanguages)).joined(separator: " ")
        SpotifyService.shared.searchTracks(query: query) { tracks in
            let reasons = "Songs in " + selectedLanguages.joined(separator: ", ")
            let suggestions = tracks.prefix(10).map { SuggestedTrack(track: $0, reason: reasons) }
            DispatchQueue.main.async {
                self.suggestedTracks = suggestions
            }
        }
    }

    func toggleRecording() {
        if isRecording {
            speechRecognizer.stopRecording()
            inputText = speechRecognizer.transcript
        } else {
            try? speechRecognizer.startRecording()
        }
        isRecording.toggle()
    }

    func savePlaylist() {
        let title = generatePlaylistTitle(from: situation)
        let tracks = suggestedTracks.map { $0.track }
        libraryVM.addPlaylist(title: title, tracks: tracks)
    }

    func generatePlaylistTitle(from situation: String) -> String {
        let trimmed = situation.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Sara's Mix" }
        return "\(trimmed.prefix(20)) Vibes"
    }
}
