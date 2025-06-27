import Foundation

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
    
    func fetchPopularArtists(completion: @escaping ([Artist]) -> Void) {
        guard let url = URL(string: "https://spotify23.p.rapidapi.com/search/?q=popular&type=artists&limit=10") else {
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
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let artists = json["artists"] as? [String: Any],
                      let items = artists["items"] as? [[String: Any]] else {
                    completion([])
                    return
                }

                let results: [Artist] = items.compactMap { item in
                    guard let data = item["data"] as? [String: Any],
                          let id = data["uri"] as? String,
                          let profile = data["profile"] as? [String: Any],
                          let name = profile["name"] as? String,
                          let visuals = data["visuals"] as? [String: Any],
                          let avatar = visuals["avatarImage"] as? [String: Any],
                          let sources = avatar["sources"] as? [[String: Any]],
                          let imageUrl = sources.first?["url"] as? String else {
                        return nil
                    }

                    return Artist(id: id, name: name, imageUrl: imageUrl)
                }

                completion(results)
            } catch {
                completion([])
            }
        }.resume()
    }

    func fetchBollywoodAlbums(completion: @escaping ([Album]) -> Void) {
        guard let url = URL(string: "https://spotify23.p.rapidapi.com/search/?q=bollywood&type=albums&limit=10") else {
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
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let albums = json["albums"] as? [String: Any],
                      let items = albums["items"] as? [[String: Any]] else {
                    completion([])
                    return
                }

                let results: [Album] = items.compactMap { item in
                    guard let data = item["data"] as? [String: Any],
                          let id = data["uri"] as? String,
                          let name = data["name"] as? String,
                          let coverArt = data["coverArt"] as? [String: Any],
                          let sources = coverArt["sources"] as? [[String: Any]],
                          let coverURL = sources.first?["url"] as? String,
                          let artists = data["artists"] as? [String: Any],
                          let artistItems = artists["items"] as? [[String: Any]],
                          let firstArtist = artistItems.first,
                          let profile = firstArtist["profile"] as? [String: Any],
                          let artistName = profile["name"] as? String else {
                        return nil
                    }

                    return Album(id: id, name: name, coverUrl: coverURL, artist: artistName)
                }

                completion(results)
            } catch {
                completion([])
            }
        }.resume()
    }

}
