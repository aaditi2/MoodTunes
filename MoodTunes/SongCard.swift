import SwiftUI

struct SongCard: View {
    let track: Track
    let reason: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Album Cover
                AsyncImage(url: URL(string: track.coverURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)

                // Song Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(track.artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(reason)
                        .font(.caption)
                        .foregroundColor(.blue)
                }

                Spacer()

                // Play Icon
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
