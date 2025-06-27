import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var currentMood: MoodState = .sad
    
    func updateMoodBasedOnEmotionTag(_ tag: String) {
        switch tag.lowercased() {
        case "heartbreak": currentMood = .heartbreak
        case "glowup": currentMood = .glowUp
        case "rage": currentMood = .rage
        case "chill": currentMood = .chill
        case "maincharacter": currentMood = .mainCharacter
        default: currentMood = .sad
        }
    }
}
