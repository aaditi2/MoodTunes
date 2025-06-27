import SwiftUI

struct MoodMapView: View {
    let days = Array(1...30)
    
    @State private var showLegend = false
    @State private var dropdownOffset: CGFloat = 0 // optional if you want precise button alignment
    
    let emojiMap: [Int: [String]] = [
        1: ["💖", "💃"], 2: ["🚀"], 3: ["💔", "😢"], 4: ["🚀"], 5: ["🚀"],
        6: ["😢", "💔"], 7: ["💃"], 8: ["💃"], 9: ["💔"], 10: ["🚀"],
        11: ["💃"], 12: ["💖"], 13: ["😢"], 14: ["🚀"], 15: ["🚀", "💃"],
        16: ["🚀","💃"], 17: ["💃", "😢"], 18: ["💔"], 19: ["💖"], 20: ["💃"],
        21: ["😢", "💔"], 22: ["🚀"], 23: ["💃"], 24: ["🚀"],
        25: ["💖", "😢"], 26: ["💃"], 27: ["🚀"], 28: ["💔", "😢"],
        29: ["💖", "🚀"], 30: ["💃"]
    ]
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("📅 Your MoodMap")
                            .font(.title)
                            .bold()
                        Spacer()
                        
                        // 🔘 Dropdown toggle button
                        Button(action: {
                            withAnimation {
                                showLegend.toggle()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text("Emoji Guide")
                                Image(systemName: showLegend ? "chevron.up" : "chevron.down")
                            }
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.top)
                    
                    // 🔲 Mood Grid (stays fixed regardless of dropdown)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 12) {
                        ForEach(days, id: \.self) { day in
                            VStack(spacing: 2) {
                                Text("Day \(day)")
                                    .font(.caption2)
                                    .foregroundColor(.black)
                                
                                if let emojis = emojiMap[day] {
                                    HStack(spacing: 2) {
                                        ForEach(emojis, id: \.self) { emoji in
                                            Text(emoji)
                                                .font(.system(size: 16))
                                        }
                                    }
                                } else {
                                    Text("⬜️")
                                        .font(.system(size: 16))
                                }
                            }
                            .frame(width: 48, height: 52)
                            .background(Color(.systemGray5).opacity(0.6))
                            .cornerRadius(6)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            
            // 🪂 Floating Dropdown Overlay
            if showLegend {
                VStack(alignment: .leading, spacing: 10) {
                    legendItem(emoji: "💖:", label: "Love / Healing")
                    legendItem(emoji: "🚀:", label: "Motivation")
                    legendItem(emoji: "💃:", label: "Energetic / Party")
                    legendItem(emoji: "💔:", label: "Heartbreak")
                    legendItem(emoji: "😢:", label: "Crying")
                }
                .padding()
                .background(Color.gray.opacity(0.9))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 4)
                .padding(.trailing, 20)
                .padding(.top, 75) // 👈 adjust this to align with your button
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// ⬇️ Outside the struct
func legendItem(emoji: String, label: String) -> some View {
    HStack(spacing: 8) {
        Text(emoji)
            .font(.system(size: 20))
        Text(label)
            .font(.subheadline)
            .foregroundColor(.black)
    }
}
