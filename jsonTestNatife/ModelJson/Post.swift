//
//  Post.swift
//  jsonTestNatife
//
//  Created by user on 02.09.2023.
//

import Foundation

struct Post: Decodable {
    var title: String
    var preview_text: String
    var likes_count: Int
    var timeshamp: Int
}
