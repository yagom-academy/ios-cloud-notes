//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListViewController: UIViewController {
    struct SampleMemo: Decodable {
        let title: String
        let body: String
        let lastModifiedDate: Int

        enum CodingKeys: String, CodingKey {
            case title, body
            case lastModifiedDate = "last_modified"
        }
    }

    private var sampleMemos: [SampleMemo]!
    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSampleData()
        configureView()
        configureTableView()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
    }

    private func fetchSampleData() {
        guard let data = NSDataAsset(name: "sample")?.data,
              let jsonData = try? JSONDecoder().decode([SampleMemo].self, from: data) else { return }

        sampleMemos = jsonData
    }

    private func configureTableView() {
        view.addSubview(memoListTableView)

        memoListTableView.dataSource = self
        memoListTableView.delegate = self
        memoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "temporarilyCell")
        memoListTableView.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sampleMemos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "temporarilyCell") else {
            return UITableViewCell()
        }
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = sampleMemos[indexPath.row].title
    }
}
