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
    @State private var vibe: String = ""
    @State private var scene: String = ""
    @State private var songLanguage: String = ""
    @State private var situation: String = ""

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

                    Button("Send") {
                        send()
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                }
                .padding()
            }
            .navigationTitle("Chat with Sara 💚")
            .background(navigationLinkToNowPlaying)
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
                vibe = response.vibe
                scene = response.scene
                songLanguage = response.language.isEmpty ? selectedLanguages.first ?? "" : response.language
                fetchSongs(from: response.keywords, situation: situation)
                isLoading = false
            }
        }
    }

    func fetchSongs(from keywords: [String], situation: String) {
        guard !keywords.isEmpty else { return }
        var languagesForQuery = selectedLanguages
        if !songLanguage.isEmpty {
            languagesForQuery.insert(songLanguage)
        }

        let group = DispatchGroup()
        var results: [SuggestedTrack] = []

        for keyword in keywords {
            group.enter()
            var queryParts: [String] = [keyword]
            if !situation.isEmpty {
                queryParts.append(situation)
            }
            queryParts.append(languagesForQuery.joined(separator: " "))
            let query = queryParts.joined(separator: " ")
            SpotifyService.shared.searchTracks(query: query) { tracks in
                if let track = tracks.first {
                    let reasonParts = [
                        vibe.isEmpty ? nil : vibe.capitalized + " vibe",
                        songLanguage.isEmpty ? nil : songLanguage,
                        "\"" + keyword + "\" related"
                    ].compactMap { $0 }
                    let reason = reasonParts.joined(separator: " · ")
                    results.append(SuggestedTrack(track: track, reason: reason))
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.suggestedTracks = results
        }
    }
}
