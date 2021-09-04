//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

private let reusableIdentifier = "cell"

class MemoListTableViewController: UITableViewController {

    var parsedData = [SampleData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("tableView did Load")
        decoding()
        configureTableView()
        configureNavigationBar()
    }

    @objc func pushContentPage() {
        let contentViewController = ContentViewController()
        navigationController?.pushViewController(contentViewController, animated: true)
    }

    func decoding() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else { return }
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            let parsedData = try decoder.decode([SampleData].self, from: data)
            self.parsedData = parsedData
        } catch {
            print(String(describing: error))
        }
    }

    func configureTableView() {
        tableView.register(TableCell.self, forCellReuseIdentifier: reusableIdentifier)
    }

    func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushContentPage))
    }

}

extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? TableCell else { return UITableViewCell() }

        let title = parsedData[indexPath.row].title
        let content = parsedData[indexPath.row].body
        let date = parsedData[indexPath.row].lastModified
        cell.configure(title: title, content: content, date: "\(date)")
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}
