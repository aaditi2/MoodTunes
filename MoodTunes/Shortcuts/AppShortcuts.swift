import AppIntents

struct SearchSongsIntent: AppIntent {
    static var title: LocalizedStringResource = "Search Songs"
    static var description = IntentDescription("Find songs for a situation")

    @Parameter(title: "Situation") var situation: String

    static var parameterSummary: some ParameterSummary {
        Summary("Search songs for \(\.$situation)")
    }

    static var openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        let encoded = situation.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "moodtunes://search?situation=\(encoded)")!
        return .openURL(url)
    }
}

struct TalkToSaraIntent: AppIntent {
    static var title: LocalizedStringResource = "Talk to Sara"
    static var description = IntentDescription("Start a conversation with Sara")

    @Parameter(title: "Message", default: "Hey Sara") var message: String

    static var parameterSummary: some ParameterSummary {
        Summary("Talk to Sara about \(\.$message)")
    }

    static var openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "moodtunes://chat?message=\(encoded)")!
        return .openURL(url)
    }
}

struct PlayRecommendedSongIntent: AppIntent {
    static var title: LocalizedStringResource = "Play Recommended Song"
    static var description = IntentDescription("Open MoodTunes to play a suggested track")

    static var openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        let url = URL(string: "moodtunes://play")!
        return .openURL(url)
    }
}

struct MoodTunesShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        [
            AppShortcut(intent: SearchSongsIntent(), phrases: ["Search songs for \(\.$situation)", "Find music for \(\.$situation)"]),
            AppShortcut(intent: TalkToSaraIntent(), phrases: ["Talk to Sara about \(\.$message)", "Ask Sara \(\.$message)"]),
            AppShortcut(intent: PlayRecommendedSongIntent(), phrases: ["Play recommended song in MoodTunes", "MoodTunes play my music"])
        ]
    }
}
