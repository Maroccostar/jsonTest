//
//  DetailController.swift
//  jsonTestNatife
//
//  Created by user on 15.09.2023.
//

import UIKit

class DetailController: UIViewController {

    var viewModel: PostDetailsViewModelType!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static func instantiate(with postID: Int) -> DetailController {
        let controller = DetailController.loadFromNib()
        controller.viewModel = PostDetailsViewModel(postId: postID)
        return controller
    }
    
    private lazy var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchPostDetails { [weak self] result in
            switch result {
            case .success(let post):
                self?.updateUI(with: post)
            case .failure(let error):
                debugPrint("Post fetching error: \(error)")
                self?.showError()
            }
        }
    }

}

// MARK: - Private
extension DetailController {
    
    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message:  "There was a problem loading the feed; please check your connection and try again.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func updateUI(with post: Post) {
        navigationItem.title = post.title
        textView.text = post.text
        loadImage(from: post.imageURL ?? "default_image_url")
        let likeText = "❤️ \(post.likesCount)"
        likesLabel.text = likeText
        let date = Date(timeIntervalSince1970: TimeInterval(post.timeStamp))
        dateLabel.text = formatter.string(from: date)
    }
    
    func loadImage(from imageURL: String) {
        guard let url = URL(string: imageURL) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error when using image: \(error.localizedDescription)")
                return
            }
            if let data =  data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }.resume()
    }

}
