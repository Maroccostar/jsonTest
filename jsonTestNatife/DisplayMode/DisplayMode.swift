//
//  DisplayMode.swift
//  jsonTestNatife
//
//  Created by user on 05.09.2023.
//

import Foundation

protocol DisplayModeProvider {
    var displayMode: DisplayMode { get }
}

class DefaultDisplayModeProvider: DisplayModeProvider {
    var displayMode: DisplayMode
    
    init(displayMode: DisplayMode) {
        self.displayMode = displayMode
    }
}

enum DisplayMode {
    case feedsPosts
    case specificPosts
    
    var endpointURL: URL? {
        switch self {
        case .feedsPosts:
            return URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json")
        case .specificPosts:
            return URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/%5Bid%5D.json")
        }
    }
}
