//
//  MovieRowView.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 4/6/2024.
//

import Foundation
import SwiftUI

struct MovieRowView: View {
  @ObservedObject private var viewModel: MovieRowViewModel
  @State private var posterImage: Image?
  @State private var error: Error?
  
  init(movie: Movie, imageLoader: ImageDownloader) {
    self._viewModel = ObservedObject(wrappedValue: MovieRowViewModel(movie: movie, imageLoader: imageLoader))
  }
  
  var body: some View {
    VStack {
      Text(String(viewModel.title))
      
      if let _ = error {
        Text("Image Error")
      } else if let posterImage = posterImage {
        posterImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 256, height: 256)
      } else {
        ProgressView()
          .frame(width: 256, height: 256)
          .task {
            do {
              self.posterImage = try await viewModel.posterImage
            } catch {
              self.error = error
            }
          }
      }
    }
  }
  
  func cancelImageDownload() {
    viewModel.cancelImageDownload()
  }
}
