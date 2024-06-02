//
//  MovieListViewModel.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 22/5/2024.
//

import Foundation
import SwiftUI

@MainActor
final class MovieListViewModel: ObservableObject {
  @Published var movieRowItems = [MovieRowItem]()
  @Published var isLoading = false
  
  private let movieService: MovieService
  private let imageLoader: ImageLoader
  
  init(movieService: MovieService = MovieService(),
       imageLoader: ImageLoader = ImageLoader()) {
    self.movieService = movieService
    self.imageLoader = imageLoader
  }
  
  func fetchMovieList() {
    isLoading = true
    Task {
      let movies = await movieService.getPopularMovies()
      let movieRowItems = movies.map { MovieRowItem(id: $0.id, title: $0.title,posterPath: $0.posterPath, imageLoader: imageLoader) }
      self.movieRowItems = movieRowItems
      isLoading = false
    }
  }
  
  func loadImage(for movieId: Int) {
    if let index = movieRowItems.firstIndex(where: { $0.id == movieId }),
       let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movieRowItems[index].posterPath)") {
      movieRowItems[index].loadImage(from: imageUrl)
    }
  }
    
  func cancelLoadImage(for movieId: Int) {
    if let index = movieRowItems.firstIndex(where: { $0.id == movieId }),
       movieRowItems[index].posterImage == nil {
      movieRowItems[index].cancelLoadingImage()
    }
  }
}
