//
//  MovieRowViewModel.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 4/6/2024.
//

import Foundation
import SwiftUI

@MainActor
class MovieRowViewModel: ObservableObject {
  private let movie: Movie
  private let imageLoader: ImageDownloader
  private var imageDownloadTask: Task<Image, Error>?
  
  var title: String {
    movie.title
  }
  
  var posterImage: Image? {
    get async throws {
      self.imageDownloadTask = Task {
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
          let image = try await imageLoader.downloadImage(from: imageUrl)
          return image
        } else {
          throw ImageError.imageUrlInvalid
        }
      }
      return try await self.imageDownloadTask?.value
    }
  }
  
  init(movie: Movie, imageLoader: ImageDownloader) {
    self.movie = movie
    self.imageLoader = imageLoader
  }
  
  func cancelImageDownload() {
    imageDownloadTask?.cancel()
  }
}
