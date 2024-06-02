//
//  ContentView.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 22/5/2024.
//

import SwiftUI

struct MovieListView: View {
  @StateObject var viewModel = MovieListViewModel()
  
  var body: some View {
    ZStack {
      VStack {
        List($viewModel.movieRowItems) { $movie in
          RowView(movie: movie)
            .onAppear {
              viewModel.loadImage(for: $movie.id)
            }
            .onDisappear {
              viewModel.cancelLoadImage(for: $movie.id)
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

struct RowView: View {
  @ObservedObject var movie: MovieRowItem
  
  var body: some View {
    VStack {
      Text(String(movie.title))

      if let posterImage = movie.posterImage {
        posterImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 256, height: 256)
      } else {
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
