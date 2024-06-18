//
//  ImageListLoaderUITests.swift
//  ImageListLoaderUITests
//
//  Created by Stanley Darmawan on 18/6/2024.
//

import XCTest

final class ImageListLoaderUITests: XCTestCase {
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {
  }
  
  func testNavigatingToMovieListView() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    
    let nextButton = app.buttons["Go to Movie List View"]
    nextButton.tap()
            
    let navigationTitle = app.staticTexts["Movie List"]
    XCTAssertTrue(navigationTitle.exists)
  }
}
