//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListTableViewController: UITableViewController {

    // MARK: - Property
    private let reusableIdentifier = "cell"
    private var parsedDatas = [SampleData]()
    weak var delegate: MemoListTableViewControllerDelegate?
    var token: NSObjectProtocol?

    // MARK: - Deinitializer
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.fetchMemo()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        decoding()
        configureTableView()
        configureNavigationBar()

        addObserverToMemoInsert()
        addObserverToMemoDelete()
    }

}
extension MemoListTableViewController {
    // MARK: - Selector
    @objc private func pushContentPage() {
        let contentViewController = ContentViewController()
        navigationController?.pushViewController(contentViewController, animated: true)
    }

    // MARK: - Method
    private func addObserverToMemoInsert() {
        token = NotificationCenter.default.addObserver(forName: Notification.Name(.newMemoDidInput), object: nil, queue: .main, using: { [weak self] _ in
            self?.tableView.reloadData()
        })
    }

    private func addObserverToMemoDelete() {
        token = NotificationCenter.default.addObserver(forName: Notification.Name(.memoDidDelete), object: nil, queue: .main, using: { [weak self] _ in
            self?.tableView.reloadData()
        })
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

    var datas: [MemoListBranching] {
        if DataManager.shared.memoList.count > 0 {
            return DataManager.shared.memoList
        }
        return parsedDatas
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataManager.shared.memoList.count > 0 {
            return datas.count
        }
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        let memo = datas[indexPath.row]
        cell.configure(title: memo.specificBranchTitle, content: memo.specificBranchContent, date: memo.specificBranchInsertDate)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = splitViewController?.viewControllers.last as? UINavigationController
        navigationController?.popToRootViewController(animated: false)

        let contentViewController = ContentViewController()

        let content = datas[indexPath.row].specificBranchContent
        delegate?.didTapMemo(self, memo: content)
        if let memoEntity = datas[indexPath.row] as? MemoEntity {
            contentViewController.memoEntity = memoEntity
        }
        contentViewController.memo = content

        navigationController?.pushViewController(contentViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if DataManager.shared.memoList.count > 0 {
                let memo = DataManager.shared.memoList[indexPath.row]
                DataManager.shared.deleteMemo(memo)
                DataManager.shared.memoList.remove(at: indexPath.row)
            } else {
                parsedDatas.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
