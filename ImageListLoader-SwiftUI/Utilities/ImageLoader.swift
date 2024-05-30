//
//  ImageLoader.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 28/5/2024.
//

import SwiftUI
import Combine

final class ImageLoader {
  class func fetchImage(from url: URL) async throws -> Image {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let uiImage = UIImage(data: data) else {
      throw URLError(.badServerResponse)
    }
    return Image(uiImage: uiImage)
  }
}
