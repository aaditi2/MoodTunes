import SwiftUI

struct ChatView: View {
    @EnvironmentObject var moodVM: MoodViewModel
    @State private var userInput = ""
    @State private var chatHistory: [String] = [
        "Sara: Hey love 💕 What’s going on in your heart today?"
    ]

    var body: some View {
        ZStack {
            moodVM.currentMood.gradient
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.0), value: moodVM.currentMood)

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(chatHistory, id: \.self) { message in
                            Text(message)
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: message.hasPrefix("Sara") ? .leading : .trailing)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }

                Divider().background(Color.white.opacity(0.2))

                HStack {
                    TextField("Tell Sara how you're feeling…", text: $userInput)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)

                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding()
            }
        }
    }

    func sendMessage() {
        guard !userInput.isEmpty else { return }

        chatHistory.append("You: \(userInput)")

        let lowercaseInput = userInput.lowercased()

        // Sara's response logic
        if lowercaseInput.contains("heartbreak") || lowercaseInput.contains("ex") || lowercaseInput.contains("left me") {
            chatHistory.append("Sara: Heartbreak hurts, I know 💔 Here's a glow-up playlist just for you.")
            moodVM.updateMoodBasedOnEmotionTag("heartbreak")
        } else if lowercaseInput.contains("happy") || lowercaseInput.contains("glow up") || lowercaseInput.contains("confident") {
            chatHistory.append("Sara: Yaaas 💅 You're glowing! Let's vibe with some main character music.")
            moodVM.updateMoodBasedOnEmotionTag("glowup")
        } else if lowercaseInput.contains("angry") || lowercaseInput.contains("frustrated") {
            chatHistory.append("Sara: Rage mode activated 😤 Here's your 'burn it all down' playlist 🔥")
            moodVM.updateMoodBasedOnEmotionTag("rage")
        } else if lowercaseInput.contains("calm") || lowercaseInput.contains("peaceful") {
            chatHistory.append("Sara: Soft and lo-fi vibes coming your way 🌙")
            moodVM.updateMoodBasedOnEmotionTag("chill")
        } else if lowercaseInput.contains("lost") || lowercaseInput.contains("empty") {
            chatHistory.append("Sara: You’re not alone 🫂 Let's sit with this feeling — I’ll play something soft.")
            moodVM.updateMoodBasedOnEmotionTag("sad")
        } else {
            chatHistory.append("Sara: Got it, love. Here's something to match your vibe 💜")
            moodVM.updateMoodBasedOnEmotionTag("chill")
        }

        userInput = ""
    }
}
