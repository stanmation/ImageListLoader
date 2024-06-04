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
  @Published var isLoading = false
  @Published var movies = [Movie]()
  
  private let movieService: MovieService
  
  init(movieService: MovieService = MovieService()) {
    self.movieService = movieService
  }
  
  func fetchMovieList() {
    isLoading = true
    Task {
      self.movies = await movieService.getPopularMovies()
      isLoading = false
    }
  }
}
