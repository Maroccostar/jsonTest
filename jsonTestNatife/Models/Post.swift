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
    case noPostFound
}

// MARK: - Post
struct Post: Decodable {
    var postId: Int
    var title: String
    var textPreview: String?
    var likesCount: Int
    var timeStamp: Int
    var text: String?
    var imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case postId
        case title
        case textPreview = "preview_text"
        case likesCount = "likes_count"
        case timeStamp = "timeshamp"
        case text
        case imageURL = "postImage"
    }
}
