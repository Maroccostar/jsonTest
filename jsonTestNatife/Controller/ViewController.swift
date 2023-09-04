//
//  ViewController.swift
//  jsonTestNatife
//
//  Created by user on 01.09.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    let temporaryArray: [String] = ["0", "1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - Private
private extension ViewController {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
    }
    
    func presentItemDetails(_ item: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "secondVC")
        vc.navigationItem.title = item
        navigationController?.pushViewController(vc, animated: true)
    }
}



// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentItemDetails(temporaryArray[indexPath.row])

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temporaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = temporaryArray[indexPath.row]
        return cell
    }
    
    
}
