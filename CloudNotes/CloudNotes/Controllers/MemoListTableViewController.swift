//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

// MARK: - Global Variable
private let reusableIdentifier = "cell"
private var parsedDatas = [SampleData]()

class MemoListTableViewController: UITableViewController {
    // MARK: - Property
    weak var delegate: MemoListTableViewControllerDelegate?

    // MARK: - Date Formatter
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .short
        f.locale = Locale(identifier: "ko_kr")
        return f
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print("tableView did Load")
        decoding()
        configureTableView()
        configureNavigationBar()
    }

}
extension MemoListTableViewController {
    // MARK: - Method
    @objc func pushContentPage() {
        let contentView = ContentViewController()
        navigationController?.pushViewController(contentView, animated: true)
    }

    func configureTableView() {
        tableView.register(TableCell.self, forCellReuseIdentifier: reusableIdentifier)
    }

    func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushContentPage))
    }
}

// MARK: - TableView Delegate Method
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? TableCell else { return UITableViewCell() }

        let title = parsedDatas[indexPath.row].title
        let content = parsedDatas[indexPath.row].body

        let date = formatter.string(from: Date(timeIntervalSince1970: Double(parsedDatas[indexPath.row].lastModified)))
        cell.configure(title: title, content: content, date: "\(date)")
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (splitViewController?.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: false)
        let body = parsedDatas[indexPath.row].body
        delegate?.didTapMemo(self, memo: body)
        let destination = UINavigationController()
        let contentViewController = ContentViewController()
        contentViewController.memo = body
        destination.viewControllers = [contentViewController]
        self.showDetailViewController(destination, sender: self)
    }
}

// MARK: - Extension method in UIViewController hierachy
extension UIViewController {
    func decoding() {
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
