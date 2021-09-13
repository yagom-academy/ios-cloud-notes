//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

// MARK: - Global Variable

class MemoListTableViewController: UITableViewController {

    // MARK: - Property
    private let reusableIdentifier = "cell"
    private var parsedDatas = [SampleData]()
    weak var delegate: MemoListTableViewControllerDelegate?

    // MARK: - Date Formatter
    private let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ko_kr")
        return formatter
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        decoding()
        configureTableView()
        configureNavigationBar()
    }

}
extension MemoListTableViewController {
    // MARK: - Method
    @objc private func pushContentPage() {
        let contentViewController = ContentViewController()
        navigationController?.pushViewController(contentViewController, animated: true)
    }

    private func configureTableView() {
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
    }

    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushContentPage))
    }

    private func decoding() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else { fatalError()}
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            let parsedData = try decoder.decode([SampleData].self, from: data)
            parsedDatas = parsedData
        } catch {
            print(String(describing: error))
        }
    }

}

// MARK: - TableView Delegate Method
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }

        let title = parsedDatas[indexPath.row].title
        let content = parsedDatas[indexPath.row].body

        let date = dateFormatter.string(from: Date(timeIntervalSince1970: Double(parsedDatas[indexPath.row].lastModified)))
        cell.configure(title: title, content: content, date: "\(date)")
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let body = parsedDatas[indexPath.row].body
        delegate?.didTapMemo(self, memo: body)

        let destination = UINavigationController()
        let contentViewController = ContentViewController()
        contentViewController.memo = body
        destination.viewControllers = [contentViewController]

        showDetailViewController(destination, sender: self)
    }
}
