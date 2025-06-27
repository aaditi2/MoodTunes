import Foundation

class TogetherService {
    static let shared = TogetherService()

    func askSara(userInput: String, languageTags: [String], completion: @escaping (String, [String]) -> Void) {
        guard let url = URL(string: "https://api.together.xyz/v1/chat/completions") else {
            completion("Sorry, couldn't connect to Sara.", [])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Secrets.togetherAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        You are Sara, a Gen-Z music therapist who replies in exactly 2 comforting lines. The user shares a situation, and you must gently reflect on it. Do NOT suggest songs in text. Instead, extract 3 strong keywords (emotions, similar movie situation resemblance, moods) at the end of your reply in this format:

        ---
        keywords: [keyword1, keyword2, keyword3]

        User message: "\(userInput)"
        Languages preferred: \(languageTags.joined(separator: ", "))
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

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion("Sorry, Sara couldn’t reply.", [])
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let reply = (json?["choices"] as? [[String: Any]])?.first?["message"] as? [String: Any]
                let fullReply = reply?["content"] as? String ?? "Sara's lost in thought..."

                // 🧠 Extract Sara's text and keywords (from `keywords: [...]`)
                let lines = fullReply.components(separatedBy: "---")
                let replyText = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Hmm..."
                let keywordLine = lines.last ?? ""
                let keywordMatch = keywordLine
                    .components(separatedBy: "[")
                    .last?
                    .components(separatedBy: "]")
                    .first?
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

                completion(replyText, keywordMatch)
            } catch {
                completion("Sara glitched out 🫠", [])
            }
        }.resume()
    }
}
