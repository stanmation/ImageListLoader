//
//  ContentView.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 22/5/2024.
//

import SwiftUI

struct MovieListView: View {
  @StateObject var viewModel = MovieListViewModel()
  private let imageLoader = ImageDownloader()
  
  var body: some View {
    ZStack {
      VStack {
        List($viewModel.movies) { $movie in
          let movieRowView = MovieRowView(movie: movie,
                                          imageLoader: imageLoader)
          movieRowView
            .onDisappear {
              movieRowView.cancelImageDownload()
            }
        }
        .onAppear {
          viewModel.fetchMovieList()
        }
      }
      
      if viewModel.isLoading {
        ProgressView()
          .frame(width: 256, height: 256)
      }
    }
  }
}

#Preview {
    MovieListView()
      .environmentObject(MovieListViewModel())
}
