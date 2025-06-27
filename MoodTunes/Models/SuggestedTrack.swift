import Foundation

struct SuggestedTrack: Identifiable {
    let track: Track
    let reason: String
    var id: String { track.id }
}
