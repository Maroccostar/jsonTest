//
//  MyTableViewCell.swift
//  jsonTestNatife
//
//  Created by user on 04.09.2023.
//

import UIKit

class PostCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostCell", bundle: nil)
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var expandButton: UIButton!
    
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var onExpandToggled: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        descriptionLabel.numberOfLines = 2
        expandButton.layer.cornerRadius = 10
        expandButton.setTitleColor(.white, for: .normal)
        expandButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 6)
    }
    
    func configure(with post: Post, isExpanded: Bool) {
        titleLabel.text = post.title
        descriptionLabel.text = post.textPreview
        likesLabel.text = "❤️ \(post.likesCount)"
        dateLabel.text = post.formatDateFromTimestamp
        expandButton.setTitle(isExpanded ? "Collapse" : "Expand", for: .normal)
        descriptionLabel.numberOfLines = isExpanded ? 0 : 2
    }
    
    @IBAction private func expandButtonTapped(_ sender: UIButton) {
        onExpandToggled?()
    }

}
