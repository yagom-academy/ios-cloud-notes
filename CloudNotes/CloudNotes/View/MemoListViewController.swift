//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

struct SampleMemo: Decodable {
    let title: String
    let description: String
    let lastModifiedDate: Double

    enum CodingKeys: String, CodingKey {
        case title
        case description = "body"
        case lastModifiedDate = "last_modified"
    }
}

class MemoListViewController: UIViewController {
    private var sampleMemos: [SampleMemo] = []
    private weak var splitViewDelegate: SplitViewDelegate?

    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(splitViewDelegate: SplitViewDelegate = SplitViewController()) {
        super.init(nibName: nil, bundle: nil)
        self.splitViewDelegate = splitViewDelegate
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSampleData()
        configureView()
        configureTableView()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
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
        memoListTableView.register(MemoPreviewCell.self, forCellReuseIdentifier: MemoPreviewCell.reusableIdentifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoPreviewCell.reusableIdentifier) else { return UITableViewCell() }

        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MemoPreviewCell else { return }

        let sampleData = sampleMemos[indexPath.row]
        let title = sampleData.title
        let date = sampleData.lastModifiedDate
        let description = sampleData.description

        cell.setTextValues(title: title, date: date, description: description)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        splitViewDelegate?.didSelectRow(data: sampleMemos[indexPath.row])
    }
}
