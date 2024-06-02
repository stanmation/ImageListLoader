//
//  MovieService.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 22/5/2024.
//

import Foundation

class MovieService: ObservableObject {
  
  private let jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    return jsonDecoder
  }()
  
  func getPopularMovies() async -> [Movie] {
    let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    let queryItems: [URLQueryItem] = [
      URLQueryItem(name: "language", value: "en-US"),
      URLQueryItem(name: "page", value: "1"),
    ]
    components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    
    guard let accessToken = Bundle.main.object(forInfoDictionaryKey:"AccessToken") as? String else {
      print("Access Token not found")
      return []
    }
    
    request.allHTTPHeaderFields = [
      "accept": "application/json",
      "Authorization": "Bearer \(accessToken)"
    ]
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      print(String(decoding: data, as: UTF8.self))
      let movieResponse = try jsonDecoder.decode(MovieResponse.self, from: data)
      return movieResponse.results
    } catch {
      print(error)
      return []
    }
  }
}

enum ServerError: Error {
  case credentialsAreNotCorrect(String)
  case technicalError(String)
  case noInternet
}
