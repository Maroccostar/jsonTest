//
//  Post.swift
//  jsonTestNatife
//
//  Created by user on 02.09.2023.
//

import Foundation

// MARK: - PostsFetchingError
enum PostsFetchingError: Error {
    case invalidURL
    case decodingError
}

// MARK: - Post
struct Post: Decodable {
    var postId: Int
    var title: String
    var preview_text: String
    var likes_count: Int
    var timeshamp: Int
}
