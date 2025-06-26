import Foundation

// MARK: - Track model
struct Track: Identifiable {
    let id: String
    let title: String
    let artist: String
    let coverURL: String
}


// MARK: - SpotifyService
class SpotifyService {
    static let shared = SpotifyService()

    let headers = [
        "X-RapidAPI-Key": Secrets.rapidAPIkey,
        "X-RapidAPI-Host": "spotify23.p.rapidapi.com"
    ]


    func searchTracks(query: String, completion: @escaping ([Track]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://spotify23.p.rapidapi.com/search/?q=\(encodedQuery)&type=tracks") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }

            do {
                guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let tracks = root["tracks"] as? [String: Any],
                      let items = tracks["items"] as? [[String: Any]] else {
                    completion([])
                    return
                }

                let results: [Track] = items.compactMap { item in
                    guard let data = item["data"] as? [String: Any],
                          let id = data["id"] as? String,
                          let name = data["name"] as? String,
                          let artists = data["artists"] as? [String: Any],
                          let artistItems = artists["items"] as? [[String: Any]],
                          let firstArtist = artistItems.first,
                          let profile = firstArtist["profile"] as? [String: Any],
                          let artistName = profile["name"] as? String,
                          let album = data["albumOfTrack"] as? [String: Any],
                          let coverArt = album["coverArt"] as? [String: Any],
                          let sources = coverArt["sources"] as? [[String: Any]],
                          let coverURL = sources.first?["url"] as? String else {
                        return nil
                    }

                    return Track(id: id, title: name, artist: artistName, coverURL: coverURL)
                }

                completion(results)
            } catch {
                completion([])
            }
        }.resume()
    }

    func fetchPreviewURL(for id: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://spotify23.p.rapidapi.com/tracks/?ids=\(id)") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let tracks = json["tracks"] as? [[String: Any]],
                   let first = tracks.first,
                   let previewURL = first["preview_url"] as? String {
                    completion(previewURL)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
