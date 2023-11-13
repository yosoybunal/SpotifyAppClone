//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 13.11.2023.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    private init() {}
    
    enum HTTPMethod: String {
        
        case GET
        case POST
        
    }
    
    struct Constants {
        
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        
        case failedToGetData
    }
    
    // MARK: - Search
    
    public func search(with query: String, completion: @escaping (Result<[SearchResults], Error>) -> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL+"/search?type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=15"), type: .GET) { request in
            let task = 
          URLSession.shared.dataTask(with: request){ data, _, error in
                print(request.url?.absoluteString ?? "none")
                guard let data = data, error == nil else { return }
                do {
                    
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)

                    var searchResults: [SearchResults] = []
                    searchResults.append(contentsOf: result.albums.items.compactMap({ SearchResults.album(model: $0) }))
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ SearchResults.track(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ SearchResults.playlist(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ SearchResults.artist(model: $0) }))
                    
                    completion(.success(searchResults))
                    print(result)
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
        
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    let json = try
                    JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    //                    JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                    completion(.success(json))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: - Get Categories
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let result = try JSONSerialization.jsonObject(with: data)
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    
    public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist?], Error>) -> Void) {
        
        let url = URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists/?limit=50")
        
        print("plalist:",url)
        createRequest(with: url, type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse,Error>) -> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + (playlist.id ?? "")), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    let result = try
                    JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    //                    JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    // MARK: - Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { baseRequest in
            //            print(baseRequest)
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    //                    print(result)
                    completion(.success(result))
                    
                } catch {
                    
                    //                    print(error.localizedDescription)
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Browse
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    //                    print(result)
                    completion(.success(result))
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
        
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistResponse, Error>)) -> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=10"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    //                    print(result)
                    completion(.success(result))
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
        
    }
    
    public func getRecommendationsGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>)) -> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    
                    let result = try
                    JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                    //                    print(result)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
        
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>)) -> Void) {
        
        let seeds = genres.joined(separator: ",")
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=10&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    
                    let result = try
                    JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                    //                    print(result)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
        
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
            
        }
        
    }
    
}
