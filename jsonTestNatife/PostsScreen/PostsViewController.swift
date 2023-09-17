//
//  PostsViewController.swift
//  jsonTestNatife
//
//  Created by user on 11.09.2023.
//

import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: PostsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBarButtons()
        setupViewModel()
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isCellExpanded(at: indexPath.row) ? UITableView.automaticDimension : 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        let post = viewModel.filteredPosts[indexPath.row]
        cell.configure(with: post, isExpanded: viewModel.isCellExpanded(at: indexPath.row))
        cell.onExpandToggled = { [weak self] in
            self?.viewModel.processCellExpand(at: indexPath.row)
            self?.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.processItemSelected(at: indexPath.row)
    }
    
}


// MARK: - Private
private extension PostsViewController {
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func sortPostsByDate() {
        viewModel.sortByDate()
        tableView.reloadData()
    }
    
    @objc func sortPostsByRating() {
        viewModel.sortByRating()
        tableView.reloadData()
    }
    
    func showPostDetails(_ post: Post) {
        let vc = DetailController.instantiate(with: post.postId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupBarButtons() {
        let sortByDateButton = UIBarButtonItem(title: "Sort by Date", style: .plain, target: self, action: #selector(sortPostsByDate))
        navigationItem.rightBarButtonItem = sortByDateButton
        let sortByRatingButton = UIBarButtonItem(title: "Sort by Rating", style: .plain, target: self, action: #selector(sortPostsByRating))
        navigationItem.leftBarButtonItem = sortByRatingButton
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.nib(), forCellReuseIdentifier: PostCell.identifier)
    }
    
    func setupViewModel() {
        viewModel = PostsViewModel()
        viewModel.onShowPostDetails = { [weak self] post in
            self?.showPostDetails(post)
        }
    
        viewModel.fetchData { [weak self] result in
            switch result {
            case.success(let posts):
                self?.viewModel.allPosts = posts
                self?.viewModel.filteredPosts = posts
                self?.tableView.reloadData()
            case.failure(let error):
                debugPrint("Posts fetching error: \(error)")
                self?.showError()
            }
        }
    }
}
