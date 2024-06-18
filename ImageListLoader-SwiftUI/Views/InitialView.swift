//
//  InitialView.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 18/6/2024.
//

import SwiftUI

struct InitialView: View {
  var body: some View {
    NavigationStack {
      Text("Click the button below to see the list of images being fetched")
        .multilineTextAlignment(.center)
      
      NavigationLink(destination: MovieListView()) {
        Text("Go to Movie List View")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(8)
      }
      .padding()
    }
  }
}

#Preview {
  InitialView()
}

