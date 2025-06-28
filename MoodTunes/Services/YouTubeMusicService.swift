import Foundation

class YouTubeMusicService {
    static let shared = YouTubeMusicService()

    private let baseURL = "https://youtube-music-api-yt.p.rapidapi.com"

    private let headers = [
        "X-RapidAPI-Key": Secrets.rapidAPIkey,
        "X-RapidAPI-Host": "youtube-music-api-yt.p.rapidapi.com"
    ]

    private func fetchJSON(endpoint: String,
                           queryItems: [URLQueryItem] = [],
                           completion: @escaping ([String: Any]?) -> Void) {
        guard var components = URLComponents(string: baseURL + endpoint) else {
            completion(nil)
            return
        }
        if !queryItems.isEmpty { components.queryItems = queryItems }
        guard let url = components.url else { completion(nil); return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            completion(json)
        }.resume()
    }

    func searchTracks(query: String, completion: @escaping ([Track]) -> Void) {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://youtube-music-api-yt.p.rapidapi.com/v2/search?query=\(encoded)") else {
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
                   let result = json["result"] as? [String: Any],
                   let songs = result["songs"] as? [[String: Any]] {
                    let tracks: [Track] = songs.compactMap { item in
                        guard let id = item["videoId"] as? String,
                              let title = item["title"] as? String,
                              let artistArray = item["artists"] as? [[String: Any]],
                              let artistName = artistArray.first?["name"] as? String,
                              let thumbnails = item["thumbnails"] as? [[String: Any]],
                              let coverURL = thumbnails.first?["url"] as? String else {
                            return nil
                        }
                        return Track(id: id, title: title, artist: artistName, coverURL: coverURL)
                    }
                    completion(tracks)
                } else {
                    completion([])
                }
            } catch {
                completion([])
            }
        }.resume()
    }

    func fetchStreamURL(for id: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://youtube-music-api-yt.p.rapidapi.com/get-stream-url?id=\(id)") else {
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
                   let url = json["url"] as? String {
                    completion(url)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    func fetchPopularArtists(completion: @escaping ([Artist]) -> Void) {
        guard let url = URL(string: "https://youtube-music-api-yt.p.rapidapi.com/charts?type=artists") else {
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
                   let result = json["result"] as? [[String: Any]] {
                    let artists: [Artist] = result.compactMap { item in
                        guard let id = item["id"] as? String,
                              let name = item["name"] as? String,
                              let thumbnails = item["thumbnails"] as? [[String: Any]],
                              let image = thumbnails.first?["url"] as? String else { return nil }
                        return Artist(id: id, name: name, imageUrl: image)
                    }
                    completion(artists)
                } else {
                    completion([])
                }
            } catch {
                completion([])
            }
        }.resume()
    }

    func fetchBollywoodAlbums(completion: @escaping ([Album]) -> Void) {
        searchTracks(query: "bollywood") { tracks in
            let albums = tracks.map { track in
                Album(id: track.id, name: track.title, coverUrl: track.coverURL, artist: track.artist)
            }
            completion(albums)
        }
    }

    // MARK: - Additional Endpoints

    func popularSearch(query: String, language: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "query", value: query),
                     URLQueryItem(name: "language", value: language)]
        fetchJSON(endpoint: "/popular/search", queryItems: items, completion: completion)
    }

    func popularCategories(language: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "language", value: language)]
        fetchJSON(endpoint: "/popular/categories", queryItems: items, completion: completion)
    }

    func popularTrends(country: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "country", value: country)]
        fetchJSON(endpoint: "/popular/trends", queryItems: items, completion: completion)
    }

    func getArtistAlbums(channelId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "channel_id", value: channelId)]
        fetchJSON(endpoint: "/get_artist_albums", queryItems: items, completion: completion)
    }

    func getArtist(channelId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "channel_id", value: channelId)]
        fetchJSON(endpoint: "/get_artist", queryItems: items, completion: completion)
    }

    func getUser(userId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "user_id", value: userId)]
        fetchJSON(endpoint: "/get_user", queryItems: items, completion: completion)
    }

    func getUserPlaylists(userId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "user_id", value: userId)]
        fetchJSON(endpoint: "/get_user_playlists", queryItems: items, completion: completion)
    }

    func getSong(videoId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "video_id", value: videoId)]
        fetchJSON(endpoint: "/get_song", queryItems: items, completion: completion)
    }

    func getSongRelated(browseId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "browse_id", value: browseId)]
        fetchJSON(endpoint: "/get_song_related", queryItems: items, completion: completion)
    }

    func getLyrics(browseId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "browse_id", value: browseId)]
        fetchJSON(endpoint: "/get_lyrics", queryItems: items, completion: completion)
    }

    func getAlbum(browseId: String, completion: @escaping ([String: Any]?) -> Void) {
        let items = [URLQueryItem(name: "browse_id", value: browseId)]
        fetchJSON(endpoint: "/get_album", queryItems: items, completion: completion)
    }
}
