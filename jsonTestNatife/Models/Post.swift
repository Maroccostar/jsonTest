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
    
    var formatDateFromTimestamp: String {
        let currentTime = Date().timeIntervalSince1970
        let elapsedTime = currentTime - TimeInterval(timeStamp)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        switch elapsedTime {
        case 0..<60:
            formatter.allowedUnits = [.second]
        case 60..<3600:
            formatter.allowedUnits = [.minute]
        case 3600..<86400:
            formatter.allowedUnits = [.hour]
        default:
            formatter.allowedUnits = [.day]
        }
        
        let timeString = formatter.string(from: elapsedTime) ?? ""
        return "\(timeString) ago"
    }
}
