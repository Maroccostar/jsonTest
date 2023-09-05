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
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilterAlert))
        navigationItem.rightBarButtonItem = filterButton
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFilter))
        navigationItem.leftBarButtonItem = resetButton
        
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
        vc.detailItem = viewModel.allPosts[indexPath.row]
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
    
    @objc func resetFilter() {
        viewModel.filteredPosts = viewModel.allPosts
        tableView.reloadData()
    }
    
    func applyFilter(with keyword: String) {
        if keyword.isEmpty {
            resetFilter()
            return
        }
        viewModel.filteredPosts = viewModel.allPosts.filter{ post in
            return post.title.lowercased().contains(keyword.lowercased())
        }
        tableView.reloadData()
    }
    
    @objc func showFilterAlert() {
        let ac = UIAlertController(title: "Post filtering", message: "Enter a string to filter", preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Enter keyword"
            textField.textColor = .systemPink
        }
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] _ in
            if let keyword = ac?.textFields?.first?.text {
                self?.applyFilter(with: keyword)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(filterAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
}
