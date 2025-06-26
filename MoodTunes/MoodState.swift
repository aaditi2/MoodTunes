import SwiftUI

enum MoodState {
    case sad, glowUp, heartbreak, rage, chill, mainCharacter

    var gradient: LinearGradient {
        switch self {
        case .sad:
            return LinearGradient(colors: [Color.gray.opacity(0.4), Color.blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        case .glowUp:
            return LinearGradient(colors: [Color.pink, Color.orange], startPoint: .top, endPoint: .bottom)
        case .heartbreak:
            return LinearGradient(colors: [Color.red.opacity(0.7), Color.black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
        case .rage:
            return LinearGradient(colors: [Color.orange, Color.red], startPoint: .top, endPoint: .bottom)
        case .chill:
            return LinearGradient(colors: [Color.purple.opacity(0.6), Color.gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
        case .mainCharacter:
            return LinearGradient(colors: [Color.purple, Color.pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
