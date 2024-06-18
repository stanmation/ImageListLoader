//
//  ImageListLoader_SwiftUITests.swift
//  ImageListLoader-SwiftUITests
//
//  Created by Stanley Darmawan on 22/5/2024.
//

import XCTest
import Combine
import SwiftUI
@testable import ImageListLoader_SwiftUI

final class MovieListViewModelTests: XCTestCase {
  private var mockMovieService: MockMovieService!
  private var viewModel: MovieListViewModel!
  private var cancellable: Set<AnyCancellable>!

  @MainActor
  override func setUp() {
    super.setUp()
    mockMovieService = MockMovieService()
    viewModel = MovieListViewModel(movieService: mockMovieService)
    cancellable = Set<AnyCancellable>()
  }
  
  override func tearDown() {
    mockMovieService = nil
    viewModel = nil
    cancellable = nil
    super.tearDown()
  }
  
  @MainActor
  func testFetchingMovieList() {
    let movie = Movie(id: 1, title: "title", posterPath: "posterPath")
    mockMovieService.movies = [movie]
    
    let expectation = XCTestExpectation()
    
    viewModel.$movies
      .sink { movies in
        if !movies.isEmpty {
          expectation.fulfill()
          XCTAssertEqual(movies.first?.id, movie.id)
          XCTAssertEqual(movies.first?.title, movie.title)
          XCTAssertEqual(movies.first?.posterPath, movie.posterPath)
        }
      }
      .store(in: &cancellable)
    
    viewModel.fetchMovieList()

    wait(for: [expectation], timeout: 1)
  }
}

class MockMovieService: MovieService {
  var movies: [Movie] = []
  
  override func getPopularMovies() async -> [Movie] {
    return movies
  }
}
