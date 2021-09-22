//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListViewController: UIViewController, PrimaryViewControllerDelegate {
    weak var splitViewDelegate: CustomSplitViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.identifier)
        return tableView
    }()
    private var memoEntityList: [MemoEntity] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchEntityList()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .white
    }
    
    func fetchEntityList() {
        memoEntityList = PersistenceManager.shared.fetchMemo()
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoEntityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier,
                                                       for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(on: memoEntityList[indexPath.row])
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        splitViewDelegate?.showDetailViewController(memoEntityList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "삭제"
        ) { (action, sourceView, completion: @escaping (Bool) -> Void) in
            self.splitViewDelegate?.initiateSecondaryViewControllerIfNeeded(self.memoEntityList[indexPath.row])
            PersistenceManager.shared.deleteMemo(entity: self.memoEntityList[indexPath.row])
            self.fetchEntityList()
            completion(true)
        }
        deleteAction.backgroundColor = .systemPink
        
        let contextualActions: [UIContextualAction] = [deleteAction]
        return UISwipeActionsConfiguration(actions: contextualActions)
    }
}
