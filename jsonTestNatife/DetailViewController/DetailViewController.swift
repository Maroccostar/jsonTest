//
//  DetailViewController.swift
//  jsonTestNatife
//
//  Created by user on 05.09.2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var detailItem: Post?
    
    var imageView: UIImageView!
    var textView: UITextView!
    var likesLabel: UILabel!
    var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        navigationItem.title = "Title"
        view.backgroundColor = .white
        
        
        setupImageView()
        setupTextView(withTitle: detailItem.title, previewText: detailItem.preview_text)
        setupLikesLabel(likesCount: detailItem.likes_count)
        setupDateLabel(timeshamp: TimeInterval(detailItem.timeshamp))
        
    }
    
}

extension DetailViewController {
    // MARK: - Methods DetailViewController
    
    private func setupImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupTextView(withTitle title: String, previewText: String) {
        
        let title = "\(detailItem?.title ?? "")\n\n"
        let fullText = title + (detailItem?.preview_text ?? "")
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.attributedText = attributedText(for: fullText)
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.sizeToFit()
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: imageView.layoutMarginsGuide.bottomAnchor, constant: 8),
            textView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupLikesLabel(likesCount: Int) {
        likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.textAlignment = .left
        view.addSubview(likesLabel)
        
        NSLayoutConstraint.activate([
            likesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            likesLabel.topAnchor.constraint(equalTo: textView.layoutMarginsGuide.bottomAnchor, constant: 8)
        ])
        
        let likes = "❤️ \(detailItem?.likes_count ?? 0)"
        likesLabel.text = likes
    }
    
    private func setupDateLabel(timeshamp: TimeInterval) {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .right
        view.addSubview(dateLabel)
        
        let date = Date(timeIntervalSince1970: timeshamp)
        let formattedDate = formatDate(date)
        dateLabel.text = formattedDate
        
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: textView.layoutMarginsGuide.bottomAnchor, constant: 8)
        ])
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func attributedText(for body: String) -> NSAttributedString {
         let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.paragraphSpacing = 10
         
         let attributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 18),
             .paragraphStyle: paragraphStyle
         ]
         
         return NSAttributedString(string: body, attributes: attributes)
     }
}
