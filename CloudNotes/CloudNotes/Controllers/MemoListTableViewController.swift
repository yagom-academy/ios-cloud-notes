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
        token = NotificationCenter.default.addObserver(forName: ContentViewController.newMemoDidInput, object: nil, queue: .main, using: { [weak self] _ in
            self?.tableView.reloadData()
        })
    }
    
    private func addObserverToMemoDelete() {
        token = NotificationCenter.default.addObserver(forName: ContentViewController.memoDidDelete, object: nil, queue: .main, using: { [weak self] _ in
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataManager.shared.memoList.count > 0 {
            return DataManager.shared.memoList.count
        }
        return parsedDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        if DataManager.shared.memoList.count > 0 {
            let memo = DataManager.shared.memoList[indexPath.row]
            guard let memoTitle = memo.title,
                  let memoContent = memo.content,
                  let memoInsertDate = memo.insertDate else { return UITableViewCell() }
            let dateToString = DataManager.shared.dateFormatter.string(from: memoInsertDate)
            
            cell.configure(title: memoTitle, content: memoContent, date: dateToString)
        } else {
            let memo = parsedDatas[indexPath.row]
            let memoTitle = memo.title
            let memoContent = memo.body
            let memoInsertDate = DataManager.shared.dateFormatter.string(from: Date(timeIntervalSince1970: Double(parsedDatas[indexPath.row].lastModified)))
            
            cell.configure(title: memoTitle, content: memoContent, date: memoInsertDate)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = splitViewController?.viewControllers.last as? UINavigationController
        navigationController?.popToRootViewController(animated: false)
        
        let contentViewController = ContentViewController()
        
        if DataManager.shared.memoList.count > 0 {
            guard let content = DataManager.shared.memoList[indexPath.row].content else { return }
            delegate?.didTapMemo(self, memo: content)
            contentViewController.memoEntity = DataManager.shared.memoList[indexPath.row]
        } else {
            let content = parsedDatas[indexPath.row].body
            delegate?.didTapMemo(self, memo: content)
            contentViewController.memo = content
        }
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
