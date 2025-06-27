import Foundation

class TogetherService {
    static let shared = TogetherService()

    func askSara(userInput: String, languageTags: [String], completion: @escaping (SaraResponse) -> Void) {
        guard let url = URL(string: "https://api.together.xyz/v1/chat/completions") else {
            let fallback = SaraResponse(reply: "Sorry, couldn't connect to Sara.")
            completion(fallback)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Secrets.togetherAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        You are Sara, a Gen-Z music therapist. Reply in exactly two comforting lines reflecting on the user's situation. Do not mention songs or share any additional metadata.

        User situation: "\(userInput)"
        Preferred languages: \(languageTags.joined(separator: ", "))
        """

        let payload: [String: Any] = [
            "model": Secrets.togetherModel,
            "max_tokens": 300,
            "temperature": 0.7,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                let fallback = SaraResponse(reply: "Sorry, Sara couldn’t reply.")
                completion(fallback)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let reply = (json?["choices"] as? [[String: Any]])?.first?["message"] as? [String: Any]
                let fullReply = reply?["content"] as? String ?? "Sara's lost in thought..."
                let replyText = fullReply.trimmingCharacters(in: .whitespacesAndNewlines)

                let response = SaraResponse(reply: replyText)
                completion(response)
            } catch {
                let fallback = SaraResponse(reply: "Sara glitched out 🫠")
                completion(fallback)
            }
        }.resume()
    }
}
