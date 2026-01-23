import SwiftUI

struct WatchHomeView: View {
    @EnvironmentObject private var moodVM: MoodViewModel
    @State private var isPlayingSuggestion = false

    var body: some View {
        VStack(spacing: 12) {
            Text("MoodTunes")
                .font(.headline)

            Text("Pick a mood")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 6) {
                moodButton(title: "Glow", tag: "glowup")
                moodButton(title: "Rage", tag: "rage")
                moodButton(title: "Chill", tag: "chill")
            }

            Button(action: playSuggestion) {
                Label("Play suggestion", systemImage: "play.fill")
                    .font(.footnote)
            }
            .buttonStyle(.borderedProminent)

            if isPlayingSuggestion {
                Text("Playing preview…")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(moodVM.currentMood.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func moodButton(title: String, tag: String) -> some View {
        Button(action: { moodVM.updateMoodBasedOnEmotionTag(tag) }) {
            Text(title)
                .font(.caption2)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func playSuggestion() {
        isPlayingSuggestion = true
    }
}

#Preview {
    WatchHomeView()
        .environmentObject(MoodViewModel())
}
