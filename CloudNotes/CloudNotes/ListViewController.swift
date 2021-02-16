//
//  CloudNotes - ListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ListViewController: UITableViewController {
    private var memoList: [Memo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeMemoData()
        setUpNavigationBar()
        setUpMemoTableView()
    }
    
    private func decodeMemoData() {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "sample") else {
            return
        }
        do {
            self.memoList = try JSONDecoder().decode([Memo].self, from: dataAsset.data)
        } catch {
            print(error)
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(moveToPostViewController))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    
    @objc private func moveToPostViewController() {
        //📍 CRUD Create 부분
    }
    
    private func setUpMemoTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationNavigationController = segue.destination as? UINavigationController,
              let detailViewController = destinationNavigationController.topViewController as? DetailViewController else {
            return
        }
        guard let cellIndex = self.tableView.indexPathForSelectedRow?.row else {
            return
        }
        detailViewController.memoTitle = memoList[cellIndex].title
        detailViewController.memoBody = memoList[cellIndex].body
    }
}

//MARK: extension TableView
extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        memoCell.accessoryType = .disclosureIndicator
        memoCell.setUpMemoCell(memoList[indexPath.row])
        return memoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

