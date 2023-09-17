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
    func isCellExpanded(at index: Int) -> Bool
    func sortByDate()
    func sortByRating()
    
    var allPosts: [Post] { get set }
    var filteredPosts: [Post] { get set }
    var onShowPostDetails: ((Post) -> Void)? { get set }
}

class PostsViewModel: PostsViewModelType {
    
    var allPosts = [Post]()
    var filteredPosts = [Post]()
    var expandedCells: [Int: Bool] = [:]
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
        if expandedCells[index] ?? false {
            expandedCells.removeValue(forKey: index)
        } else {
            expandedCells[index] = true
        }
    }
    
    func processItemSelected(at index: Int) {
        let post = filteredPosts[index]
        onShowPostDetails?(post)
    }
    
    func isCellExpanded(at index: Int) -> Bool {
        return expandedCells[index] ?? false
    }
    
    func sortByDate() {
        filteredPosts.sort(by: { $0.timeStamp > $1.timeStamp })
    }
    
    func sortByRating() {
        filteredPosts.sort(by: { $0.likesCount > $1.likesCount })
    }
    
}
