//
//  MovieRowItem.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 29/5/2024.
//

import SwiftUI

@MainActor
class MovieRowItem: Identifiable, ObservableObject {
  let id: Int
  let title: String
  let posterPath: String
  @Published var posterImage: Image?
  private var currentTask: Task<Void, Never>? = nil
  
  init(id: Int, title: String, posterPath: String) {
    self.id = id
    self.title = title
    self.posterPath = posterPath
  }
  
  func loadImage(from url: URL) {
    currentTask?.cancel()
        
    currentTask = Task {
      do {
        let image = try await ImageLoader.fetchImage(from: url)
        self.posterImage = image
      } catch {
        if !Task.isCancelled {
          print("Failed to load image: \(error)")
        }
      }
    }
  }
  
  func cancelLoadingImage() {
    currentTask?.cancel()
  }
}
