import SwiftUI

struct MessageBubbleView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}
