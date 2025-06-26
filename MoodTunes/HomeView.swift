import SwiftUI

struct HomeView: View {
    @EnvironmentObject var moodVM: MoodViewModel

    var body: some View {
        ZStack {
            moodVM.currentMood.gradient
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.0), value: moodVM.currentMood)

            VStack(spacing: 20) {
                Text("Welcome to Mood Tunes 💖")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Button("Change Mood ➡️ Glow Up") {
                    moodVM.updateMoodBasedOnEmotionTag("glowup")
                }

                Button("Change Mood ➡️ Rage") {
                    moodVM.updateMoodBasedOnEmotionTag("rage")
                }

                Button("Change Mood ➡️ Chill") {
                    moodVM.updateMoodBasedOnEmotionTag("chill")
                }
            }
        }
    }
}
