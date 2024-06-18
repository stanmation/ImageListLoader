//
//  ImageListLoader_SwiftUITests.swift
//  ImageListLoader-SwiftUITests
//
//  Created by Stanley Darmawan on 22/5/2024.
//

import XCTest
import SwiftUI
import Swift
@testable import ImageListLoader_SwiftUI

final class MovieRowViewModelTests: XCTestCase {
  private var mockImageDownloader: MockImageDownloader!
  private var viewModel: MovieRowViewModel!

  @MainActor
  override func setUp() {
    super.setUp()
    mockImageDownloader = MockImageDownloader()
    let movie = Movie(id: 1, title: "title", posterPath: "posterPath")
    viewModel = MovieRowViewModel(movie: movie, imageLoader: mockImageDownloader)
  }
  
  override func tearDown() {
    mockImageDownloader = nil
    viewModel = nil
    super.tearDown()
  }
  
  @MainActor
  func testDownloadingImageSuccessfully() async {
    do {
      let posterImage = try await viewModel.posterImage
      XCTAssertEqual(posterImage, Image("Image"))
    } catch {
      XCTFail()
    }
  }

  @MainActor
  func testDownloadingImageThenCancel() async {
    var posterImage: Image?

    mockImageDownloader.delayInSeconds = 2
    
    Task {
      do {
        posterImage = try await viewModel.posterImage
      } catch {
        XCTAssertTrue(error is CancellationError)
      }
    }
    
    try! await Task.sleep(nanoseconds: 500_000_000)
    viewModel.cancelImageDownload()

    let expectation = XCTestExpectation()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      if (posterImage == nil) {
        expectation.fulfill()
      }
    }
  
    await fulfillment(of: [expectation], timeout: 4)
  }
}

class MockImageDownloader: ImageDownloader {
  var delayInSeconds: UInt64 = 0

  override func downloadImage(from url: URL) async throws -> Image {
    try await Task.sleep(nanoseconds: delayInSeconds * 1_000_000_000)
    return Image("Image")
  }
}
