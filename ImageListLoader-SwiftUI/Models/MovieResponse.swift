//
//  MovieResponse.swift
//  ImageListLoader-SwiftUI
//
//  Created by Stanley Darmawan on 22/5/2024.
//

import Foundation
import UIKit

struct MovieResponse: Decodable {
  let results: [Movie]
}

struct Movie: Decodable {
  let id: Int
  let title: String
  let posterPath: String
}
