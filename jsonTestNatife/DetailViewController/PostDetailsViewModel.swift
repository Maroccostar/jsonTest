//
//  PostDetailsViewModel.swift
//  jsonTestNatife
//
//  Created by user on 11.09.2023.
//

import Foundation // ++


protocol PostDetailsViewModelType {

    func fetchPostDetails(postId: Int, completion: @escaping (Result<Post, Error>) -> Void)
    var postId: Int { get }
    var post: Post? { get }

}

class PostDetailsViewModel: PostDetailsViewModelType {
    let postId: Int
    var post: Post?

    init(postId: Int) {
        self.postId = postId
    }


    func fetchPostDetails(postId: Int, completion: @escaping (Result<Post, Error>) -> Void) {

        if let url = EndpointProvider.postDetails(postId).url {
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
        } else {
            completion(.failure(PostsFetchingError.invalidURL))
        }
    }
}

