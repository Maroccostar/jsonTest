//
//  PostsViewModel.swift
//  jsonTestNatife
//
//  Created by user on 05.09.2023.
//

import Foundation

protocol PostsViewModelType {
    func fetchData(completion: @escaping (Result<[Post], Error>) -> Void)
    var allPosts: [Post] { get set }
    var filteredPosts: [Post] { get set }
}

class PostsViewModel: PostsViewModelType {
    private let displayType: DisplayMode
    
    var allPosts = [Post]()
    var filteredPosts = [Post]()
    
    init(with displayType: DisplayMode) {
        self.displayType = displayType
    }
    
    func fetchData(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = displayType.endpointURL else {
            completion(.failure(PostsFetchingError.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let postsResponse = try JSONDecoder().decode(PostResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(postsResponse.posts))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
