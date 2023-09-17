//
//  EndpointProvider.swift
//  jsonTestNatife
//
//  Created by user on 11.09.2023.
//

import Foundation

enum EndpointProvider {
    case allPosts
    case postDetails(Int)
    
    var url: URL? {
        switch self {
        case .allPosts:
            return URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json")
        case .postDetails(let id):
            return URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(id).json")
        }
    }
}
