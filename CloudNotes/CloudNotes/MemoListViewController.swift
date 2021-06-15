//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/01.
//

import UIKit

class MemoListViewController: UITableViewController {
    
    var delegate: TextViewProtocol?
    var memoList = [MemoData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.title = "메모"
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: "MemoListCell")
        
        setNavigationBarButton()
        parseMemoData()
    }
    
    @objc private func addToMemo() {
        let memoFormViewController = MemoDetailViewController()
        navigationController?.pushViewController(memoFormViewController, animated: true)
    }
    
    private func setNavigationBarButton() {
        let newMemo = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToMemo))
        navigationItem.rightBarButtonItem = newMemo
    }
    
    private func parseMemoData() {
        let decoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: "sample") else {
            return
        }
        let data = dataAsset.data
        
        do {
            let result = try decoder.decode([MemoData].self, from: data)
            memoList = result
        } catch {
            print("parsing failed")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListCell") as? MemoListCell else {
            return MemoListCell()
        }
    
        cell.bindCellContent(item: memoList[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setupContent("""
        \(memoList[indexPath.row].title)

        \(memoList[indexPath.row].body)
        """)

        splitViewController?.show(.secondary)
    }
}

extension MemoListViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }
}
