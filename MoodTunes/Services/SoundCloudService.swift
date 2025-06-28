import Foundation

class SoundCloudService {
    static let shared = SoundCloudService()

    private let headers = [
        "X-RapidAPI-Key": Secrets.rapidAPIkey,
        "X-RapidAPI-Host": "soundcloud4.p.rapidapi.com"
    ]

    func searchTracks(query: String, completion: @escaping ([Track]) -> Void) {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://soundcloud4.p.rapidapi.com/search?query=\(encoded)&limit=10") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let tracks = json["tracks"] as? [[String: Any]] {
                    let results: [Track] = tracks.compactMap { item in
                        guard let id = item["id"] as? Int,
                              let title = item["title"] as? String,
                              let user = item["user"] as? [String: Any],
                              let artistName = user["username"] as? String else {
                            return nil
                        }
                        let artwork = item["artwork_url"] as? String ?? ""
                        return Track(id: String(id), title: title, artist: artistName, coverURL: artwork)
                    }
                    completion(results)
                } else {
                    completion([])
                }
            } catch {
                completion([])
            }
        }.resume()
    }
}
