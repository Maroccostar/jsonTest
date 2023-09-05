//
//  ViewController.swift
//  jsonTestNatife
//
//  Created by user on 01.09.2023.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: PostsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Title"
        
        setupTableView()
        
        let sortByDateButton = UIBarButtonItem(title: "Sort by Date", style: .plain, target: self, action: #selector(sortPostsByDateDescending))
        navigationItem.rightBarButtonItem = sortByDateButton
        let sortByRatingButton = UIBarButtonItem(title: "Sort by Rating", style: .plain, target: self, action: #selector(sortPostsByRatingDescending))
        navigationItem.leftBarButtonItem = sortByRatingButton
        
        let displayMode: DisplayMode = navigationController?.tabBarItem.tag == 0 ? .feedsPosts : .specificPosts
        
        viewModel = PostsViewModel(with: displayMode)
        viewModel.fetchData { [weak self] result in
            switch result {
            case.success(let posts):
                self?.viewModel.allPosts = posts // +
                self?.viewModel.filteredPosts = posts // +
                self?.tableView.reloadData()
            case.failure(let error):
                debugPrint("Posts fetching error: \(error)")
                self?.showError()
            }
        }
        
    }
}

// MARK: - Private
private extension ViewController {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
    }
}



// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        let post = viewModel.filteredPosts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.preview_text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = viewModel.filteredPosts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Private Methods: filter, reset, error
private extension ViewController {
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func sortPostsByDateDescending() {
        viewModel.filteredPosts.sort { (post1, post2) -> Bool in
            return post1.timeshamp > post2.timeshamp
        }
        tableView.reloadData()
    }
    
    @objc func sortPostsByRatingDescending() {
        viewModel.filteredPosts.sort { (post1, post2) -> Bool in
            return post1.likes_count > post2.likes_count
        }
        tableView.reloadData()
    }
}
