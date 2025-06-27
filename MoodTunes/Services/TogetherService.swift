import Foundation

class TogetherService {
    static let shared = TogetherService()

    func askSara(userInput: String, languageTags: [String], completion: @escaping (SaraResponse) -> Void) {
        guard let url = URL(string: "https://api.together.xyz/v1/chat/completions") else {
            let fallback = SaraResponse(reply: "Sorry, couldn't connect to Sara.", vibe: "", language: "", scene: "", keywords: [])
            completion(fallback)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Secrets.togetherAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        You are Sara, a Gen-Z music therapist who replies in exactly 2 comforting lines. The user shares a situation and you gently reflect on it. Do NOT suggest songs directly. After your two line response add details using this exact format:

        ---
        vibe: <short vibe description>
        language: <language of recommended songs>
        scene: <Bollywood movie scene with a similar situation>
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
                let fallback = SaraResponse(reply: "Sorry, Sara couldn’t reply.", vibe: "", language: "", scene: "", keywords: [])
                completion(fallback)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let reply = (json?["choices"] as? [[String: Any]])?.first?["message"] as? [String: Any]
                let fullReply = reply?["content"] as? String ?? "Sara's lost in thought..."

                // 🧠 Extract Sara's text and metadata
                let sections = fullReply.components(separatedBy: "---")
                let replyText = sections.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Hmm..."

                var vibe = ""
                var language = ""
                var scene = ""
                var keywords: [String] = []

                if sections.count > 1 {
                    let metaLines = sections[1].components(separatedBy: "\n")
                    for line in metaLines {
                        let trimmed = line.trimmingCharacters(in: .whitespaces)
                        if trimmed.lowercased().hasPrefix("vibe:") {
                            vibe = trimmed.replacingOccurrences(of: "vibe:", with: "").trimmingCharacters(in: .whitespaces)
                        } else if trimmed.lowercased().hasPrefix("language:") {
                            language = trimmed.replacingOccurrences(of: "language:", with: "").trimmingCharacters(in: .whitespaces)
                        } else if trimmed.lowercased().hasPrefix("scene:") {
                            scene = trimmed.replacingOccurrences(of: "scene:", with: "").trimmingCharacters(in: .whitespaces)
                        } else if trimmed.lowercased().hasPrefix("keywords:") {
                            let keywordLine = trimmed
                                .components(separatedBy: "[")
                                .last?
                                .components(separatedBy: "]")
                                .first?
                            if let line = keywordLine {
                                keywords = line.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            }
                        }
                    }
                }

                let response = SaraResponse(reply: replyText, vibe: vibe, language: language, scene: scene, keywords: keywords)
                completion(response)
            } catch {
                let fallback = SaraResponse(reply: "Sara glitched out 🫠", vibe: "", language: "", scene: "", keywords: [])
                completion(fallback)
            }
        }.resume()
    }
}
