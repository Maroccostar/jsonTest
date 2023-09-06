//
//  MyTableViewCell.swift
//  jsonTestNatife
//
//  Created by user on 04.09.2023.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    @IBOutlet private weak var titleLabel: UILabel! // +
    @IBOutlet private weak var descriptionLabel: UILabel! // +
    @IBOutlet weak var expandButton: UIButton! // +
    
    var isExpanded = false // +
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        descriptionLabel.numberOfLines = 2 // +
    }
    
    func configure(with post: Post) { // +
        titleLabel.text = post.title
        descriptionLabel.text = post.preview_text
        isExpanded = false
        updateCellUI()
        
    }
    
    @IBAction private func expandButtonTapped(_ sender: UIButton) { // +
        isExpanded.toggle()
        updateCellUI()
    }
    
    private func updateCellUI() { // +
        if isExpanded {
            descriptionLabel.numberOfLines = 0
            expandButton.setTitle("Collapse", for: .normal)
            configureButtonCollapseAndExpand()
        } else {
            descriptionLabel.numberOfLines = 2
            expandButton.setTitle("Expand", for: .normal)
            configureButtonCollapseAndExpand()
        }
    }
    
    private let darkerGrayColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0) // +
    
    private func configureButtonCollapseAndExpand() { // +
        expandButton.backgroundColor = darkerGrayColor
        expandButton.layer.cornerRadius = 10
        expandButton.setTitleColor(.white, for: .normal)
        expandButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 6)
    }

}
