//
//  PostsViewModel.swift
//  jsonTestNatife
//
//  Created by user on 11.09.2023.
//

import Foundation

protocol PostsViewModelType {
    func fetchData(completion: @escaping (Result<[Post], Error>) -> Void)
    func processCellExpand(at index: Int)
    func processItemSelected(at index: Int)
    
    var allPosts: [Post] { get set }
    var filteredPosts: [Post] { get set }
    var onShowPostDetails: ((Post) -> Void)? { get set }
}

class PostsViewModel: PostsViewModelType {
    
    var allPosts = [Post]()
    var filteredPosts = [Post]()
    var indexesOfExpandedPosts: [Int] = []
    var onShowPostDetails: ((Post) -> Void)?
    
    func fetchData(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = EndpointProvider.allPosts.url else {
            completion(.failure(PostsFetchingError.invalidURL))
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let postsResponse = try JSONDecoder().decode(PostResponse.self, from: data)

                let postsWithDateAndRating = postsResponse.posts.map { post in
                    return Post(postId: post.postId,
                                title: post.title,
                                textPreview: post.textPreview,
                                likesCount: post.likesCount,
                                timeStamp: post.timeStamp,
                                text: post.text,
                                imageURL: post.imageURL
                    )
                }
                self?.allPosts = postsWithDateAndRating
                self?.filteredPosts = postsWithDateAndRating

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
    
    func processCellExpand(at index: Int) {
        // add index to expanded or remove
    }
    
    func processItemSelected(at index: Int) {
        let post = filteredPosts[index]
        onShowPostDetails?(post)
    }
    
}
