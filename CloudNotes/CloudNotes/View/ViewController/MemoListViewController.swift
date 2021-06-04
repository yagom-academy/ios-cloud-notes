//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 
import Foundation
import UIKit

class MemoListViewController: UIViewController {
    
    let tableView = UITableView()
    var memoSplitViewController: MemoSplitViewController?
    lazy var rightNvigationItem: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addNewMemo), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpTableView()
        setUpNavigationBar()
    }
    
    @objc private func addNewMemo() {
        JsonDataCache.shared.decodedJsonData.insert(Memo(title: "", body: ""), at: 0)
        tableView.reloadData()
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNvigationItem)
        self.navigationItem.title = "메모"
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setUpTableView() {
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MemoListTableViewCell.classForCoder(),forCellReuseIdentifier:MemoListTableViewCell.identifier)
        self.setTableViewLayout()
    }
    
    private func setTableViewLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
        ])
    }
    
    private func presentAlertForDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default) { [weak self] action in
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action in
            self?.memoSplitViewController?.detail.deleteMemo(indexPath: indexPath)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func shareMemo(indexPath: IndexPath) {
        let memo = JsonDataCache.shared.decodedJsonData[indexPath.row]
        let text = "\n" + memo.computedTitle + "\n\n" + memo.computedBody
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
    }
    
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JsonDataCache.shared.decodedJsonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier : MemoListTableViewCell.identifier) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: JsonDataCache.shared.decodedJsonData[indexPath.row])
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoSplitViewController = memoSplitViewController else {
            return
        }
        memoSplitViewController.detail.configure(with: JsonDataCache.shared.decodedJsonData[indexPath.row], indexPath: indexPath)
        memoSplitViewController.showDetailViewController(UINavigationController(rootViewController: memoSplitViewController.detail), sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share...") { [weak self] (action, view, completionhalder) in
            self?.shareMemo(indexPath: indexPath)
            completionhalder(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionhalder) in
            self?.presentAlertForDelete(indexPath: indexPath)
            completionhalder(true)
        }
        return UISwipeActionsConfiguration(actions: [shareAction, deleteAction])
    }
}

