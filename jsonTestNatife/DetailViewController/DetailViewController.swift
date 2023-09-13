//
//  DetailViewController.swift
//  jsonTestNatife
//
//  Created by user on 05.09.2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var viewModel: PostDetailsViewModelType!
    
    var imageView: UIImageView!
    var textView: UITextView!
    var likesLabel: UILabel!
    var dateLabel: UILabel!
    let colorHex = UIColor(hex: "46505A")
    
    init(with postID: Int) {
        self.viewModel = PostDetailsViewModel(postId: postID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  "\(viewModel.post?.title ?? "")"
        view.backgroundColor = .white
        
        setupImageView()
        setupTextView()
        setupLikesLabel()
        setupDateLabel()
        
        
        viewModel.fetchPostDetails(completion: { [weak self] result in
            switch result {
            case .success(let post):
                self?.updateUI(with: post)
            case .failure(let error):
                debugPrint("Post fetching error: \(error)")
                self?.showError()
            }
        })
    }
}

// MARK: - Private
private extension DetailViewController {
    
    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message: "There was a problem loading the feed; please check your connection and try again.",
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
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }.resume()
    }
    
    
    func setupImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    func setupTextView() {
        
        let title = "\(viewModel.post?.title ?? "")\n\n"
        let fullText = title + (viewModel.post?.text ?? "")
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.attributedText = attributedText(for: fullText)
        textView.isEditable = false
        textView.textColor = colorHex
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.sizeToFit()
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: imageView.layoutMarginsGuide.bottomAnchor, constant: 8),
            textView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func setupLikesLabel() {
        likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.textAlignment = .left
        likesLabel.textColor = colorHex
        view.addSubview(likesLabel)

        NSLayoutConstraint.activate([
            likesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            likesLabel.topAnchor.constraint(equalTo: textView.layoutMarginsGuide.bottomAnchor, constant: 8)
        ])

        let likes = "❤️ \(viewModel.post?.likesCount ?? 0)"
        likesLabel.text = likes
    }
    
    func setupDateLabel() {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .right
        dateLabel.textColor = colorHex
        view.addSubview(dateLabel)

        let date = Date(timeIntervalSince1970: TimeInterval(viewModel.post?.timeStamp ?? 0))
        let formattedDate = formatter.string(from: date)
        dateLabel.text = formattedDate

        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: textView.layoutMarginsGuide.bottomAnchor, constant: 8)
        ])
    }

    func attributedText(for body: String) -> NSAttributedString {
         let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.paragraphSpacing = 10

         let attributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 18),
             .paragraphStyle: paragraphStyle
         ]

         return NSAttributedString(string: body, attributes: attributes)
     }
}
