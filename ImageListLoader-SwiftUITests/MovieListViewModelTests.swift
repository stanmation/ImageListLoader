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
  private var mockImageLoader: MockImageLoader!
  private var viewModel: MovieListViewModel!
  private var cancellable = Set<AnyCancellable>()

  @MainActor
  override func setUp() {
    super.setUp()
    mockMovieService = MockMovieService()
    mockImageLoader = MockImageLoader()
    viewModel = MovieListViewModel(movieService: mockMovieService, imageLoader: mockImageLoader)
  }
  
  @MainActor
  func testFetchingMovieList() {
    let movie = Movie(id: 1, title: "title", posterPath: "posterPath")
    mockMovieService.movies = [movie]
    let expectation = XCTestExpectation()
    
    viewModel.$movieRowItems
      .sink { movieRowItems in
        if !movieRowItems.isEmpty {
          expectation.fulfill()
          XCTAssertEqual(movieRowItems.first?.id, movie.id)
          XCTAssertEqual(movieRowItems.first?.title, movie.title)
          XCTAssertEqual(movieRowItems.first?.posterPath, movie.posterPath)
        }
      }
      .store(in: &cancellable)
    
    viewModel.fetchMovieList()

    wait(for: [expectation], timeout: 1)
  }
  
  @MainActor
  func testLoadingImageSuccessfully() {
    let movieId = 1
    let movieRowItem = MovieRowItem(id: movieId, title: "title", posterPath: "path", imageLoader: mockImageLoader)
    
    viewModel.movieRowItems = [
      movieRowItem
    ]
        
    let expectation = XCTestExpectation()
    
    movieRowItem.$posterImage
      .sink { posterImage in
        if let posterImage = posterImage {
          expectation.fulfill()
          XCTAssertEqual(posterImage, Image("Image"))
        }
      }
      .store(in: &cancellable)
    
    viewModel.loadImage(for: movieId)

    wait(for: [expectation], timeout: 2)
  }
  
  @MainActor
  func testLoadingImageThenCancel() {
    let movieId = 1
    let movieRowItem = MovieRowItem(id: movieId, title: "title", posterPath: "path", imageLoader: mockImageLoader)
    
    viewModel.movieRowItems = [
      movieRowItem
    ]
    
    mockImageLoader.delayInSeconds = 1
        
    viewModel.loadImage(for: movieId)
    viewModel.cancelLoadImage(for: movieId)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      XCTAssertNil(movieRowItem.posterImage)
    }
  }
}

class MockMovieService: MovieService {
  var movies: [Movie] = []
  
  override func getPopularMovies() async -> [Movie] {
    return movies
  }
}

class MockImageLoader: ImageLoader {
  var delayInSeconds: UInt64 = 0
  
  override func fetchImage(from url: URL) async throws -> Image {
    try await Task.sleep(nanoseconds: delayInSeconds * 1_000_000_000)
    return Image("Image")
  }
}
