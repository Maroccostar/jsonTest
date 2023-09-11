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
    @IBOutlet private weak var contentViewCollection: UICollectionView!
    
    var isExpanded = false
    var onExpandToggled: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        descriptionLabel.numberOfLines = 2
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        descriptionLabel.text = post.textPreview
        likesLabel.text = "❤️ \(post.likesCount)"
        dateLabel.text = formatDateFromTimestamp(post.timeStamp)
        isExpanded = false
        updateCellUI()
    }
    
    @IBAction func expandButtonTapped(_ sender: UIButton) {
        isExpanded.toggle()
        onExpandToggled?()
        updateCellUI()
    }
    
    
    private func updateCellUI() {
        descriptionLabel.numberOfLines = isExpanded ? 0 : 2
        expandButton.setTitle(isExpanded ? "Collapse" : "Expand", for: .normal)
        configureButtonCollapseAndExpand()
    }
    
    private func configureButtonCollapseAndExpand() {
        expandButton.layer.cornerRadius = 10
        expandButton.setTitleColor(.white, for: .normal)
        expandButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 6)
    }
    
    func formatDateFromTimestamp(_ timestamp: Int) -> String {
        let currentTime = Date().timeIntervalSince1970
        let elapsedTime = currentTime - TimeInterval(timestamp)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        switch elapsedTime {
        case 0..<60:
            formatter.allowedUnits = [.second]
        case 60..<3600:
            formatter.allowedUnits = [.minute]
        case 3600..<86400:
            formatter.allowedUnits = [.hour]
        default:
            formatter.allowedUnits = [.day]
        }
        
        let timeString = formatter.string(from: elapsedTime) ?? ""
        return "\(timeString) ago"
    }

}
