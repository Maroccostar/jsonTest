//
//  PostDetailsViewModel.swift
//  jsonTestNatife
//
//  Created by user on 11.09.2023.
//

import Foundation


protocol PostDetailsViewModelType {
    
    var postId: Int { get }
    var post: Post? { get }
    func fetchPostDetails(completion: @escaping (Result<Post, Error>) -> Void)
}

class PostDetailsViewModel: PostDetailsViewModelType {
    let postId: Int
    var post: Post?
    
    init(postId: Int) {
        self.postId = postId
    }
    
    
    func fetchPostDetails(completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = EndpointProvider.postDetails(postId).url else {
            completion(.failure(PostsFetchingError.invalidURL))
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let postResponse = try JSONDecoder().decode(PostDetailsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(postResponse.post))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

